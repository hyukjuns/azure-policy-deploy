# Azure Policy Create and Deploy

### Cheatsheets
```

# pathexpand : 경로 중 '~' 이 있다면  현재 사용자의 홈 디렉토리 경로로 변경
> pathexpand("~/.ssh/id_rsa")
/home/steve/.ssh/id_rsa

# basename : 파일시스템 경로중 마지막 경로 부분을 제외한 모든 앞부분 경로 제거
> basename("foo/bar/baz.txt")
baz.txt
```

### Ref
- [terraform-azurerm-policy-as-code](https://github.com/gettek/terraform-azurerm-policy-as-code/tree/main)