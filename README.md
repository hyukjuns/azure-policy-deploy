# Azure Policy Create and Deploy

### Cheatsheets
```
# Policy Scan
az policy state trigger-scan

# pathexpand : 경로 중 '~' 이 있다면  현재 사용자의 홈 디렉토리 경로로 변경
> pathexpand("~/.ssh/id_rsa")
/home/steve/.ssh/id_rsa

# basename : 파일시스템 경로중 마지막 경로 부분을 제외한 모든 앞부분 경로 제거
> basename("foo/bar/baz.txt")
baz.txt
```

### Condition 사용 참고
- 배열 참조

    ```
    Microsoft.Test/resourceType/stringArray	 --> ["a", "b", "c"]
    Microsoft.Test/resourceType/stringArray[*]	--> "a", "b", "c"
    ```
- 평가 대상이 비어 있는 배열일 경우 조건 평가 결과는 항상 True
    
    빈배열은 배열 요소를 평가하는 조건식에 어긋나지 않기때문에 항상 True를 반환함, 때문에 원하는 결과값과 빈배열의 결과를 같게 만드는 것이 중요함

- 위처럼 빈배열의 특수한 경우를 제외하기 위해서는 **count**를 사용해서 조건 결과인 참 or 거짓의 개수를 세는것이 좋음, 만약, **not**을 사용해야 한다면 빈배열의 경우를 포함하여 결과값으로 나올 수 있는 경우의 수를 잘 세워야 함

- (Example)  빈 배열 혹은 배열 요소가 특정 IP일 경우 조건 평가 결과로 False를 받아야 할 경우

    ```
    "not": {
        "field": "Microsoft.Network/networkSecurityGroups/securityRules/sourceAddressPrefixes[*]",
        "notIn": [
              "*",
              "Internet"
            ]
        }
    ```
    |조건식\배열값|Empty|Internet|1.2.3.4|
    |---|---|---|---|
    |in|True|True|False|
    |notIn|True|False|True|
    |**not(notIn)**|**False**|**True**|**False**|
    |not(in)|False|False|True|


### Ref
- [terraform-azurerm-policy-as-code](https://github.com/gettek/terraform-azurerm-policy-as-code/tree/main)