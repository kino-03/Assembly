# 5개 정수의 평균 계산 프로그램 (Assembly)

사용자가 입력한 **정수 5개의 합계를 구한 뒤 평균을 소수점 둘째 자리까지 출력**하는 x86 어셈블리 프로그램입니다. Windows에서 동작하며, [Flat Assembler(FASM)](https://flatassembler.net/download.php)로 실행 파일을 생성합니다.

## 기능

- 정수 5개를 순서대로 입력받습니다.
- 입력된 정수들의 합계를 계산하고 5로 나눕니다.
- 계산 결과를 `Average: 30.00`과 같이 소수점 둘째 자리까지 출력합니다.
- 음수와 0을 입력할 수 있으며, 합계 계산에 64비트 정수를 사용합니다.
- 정수 대신 다른 문자를 입력하면 오류 메시지를 출력합니다.

## 실행 환경

| 항목 | 내용 |
| --- | --- |
| 운영체제 | Windows 10 / 11 (32비트 프로그램 실행 가능 환경) |
| 편집기 | Visual Studio Code (선택) |
| 어셈블러 | FASM for Windows |
| 코드 형식 | x86(32비트) PE 콘솔 프로그램 |
| 실행 방식 | 로컬 `.exe` 실행 (우분투/WSL/별도 링커 불필요) |

> VS Code는 코드 편집기이므로 `.asm` 파일만으로는 실행되지 않습니다. 압축 해제해서 사용할 수 있는 FASM 어셈블러가 한 번 필요합니다.

## 파일 구성

```text
integer-average-assembly/
├── average.asm             # 어셈블리 소스 코드
├── run.bat                 # 빌드 및 실행용 Windows 배치 파일
├── README.md               # 프로젝트 설명 문서
└── images/
    └── execution.png       # 실행 화면 예시 이미지
```

## 실행 방법 (Windows + VS Code)

**1. FASM 준비**

1. [FASM 다운로드 페이지](https://flatassembler.net/download.php)에서 Windows용 압축 파일(`fasmw...zip`)을 받습니다.
2. 압축을 풀어 `C:\fasm\FASM.EXE` 및 `C:\fasm\INCLUDE\WIN32A.INC` 파일이 존재하도록 배치합니다.
3. VS Code에서 이 프로젝트 폴더를 엽니다.

**2. 빌드 및 실행**

VS Code의 **터미널 → 새 터미널**을 열고 다음 명령을 입력합니다.

```powershell
.\run.bat
```

스크립트가 `average.asm`을 `average.exe`로 빌드한 다음 자동 실행합니다.

직접 컴파일하고 싶다면 PowerShell에서 다음과 같이 실행할 수 있습니다.

```powershell
$env:INCLUDE = "C:\fasm\INCLUDE"
& "C:\fasm\FASM.EXE" ".\average.asm" ".\average.exe"
.\average.exe
```

## 실행 결과

다음은 `10`, `20`, `30`, `40`, `50`을 입력한 경우의 **실행 화면 예시**입니다.

![5개 정수 평균 계산 프로그램 실행 결과 예시](images/execution.png)

```text
Enter integer 1: 10
Enter integer 2: 20
Enter integer 3: 30
Enter integer 4: 40
Enter integer 5: 50

Average: 30.00
```

> 이미지와 텍스트는 예상되는 콘솔 입출력을 재현한 예시입니다. 실제 Windows 실행 환경에서 캡처한 검증 스크린샷은 아닙니다.

## 계산 과정

입력값이 `10, 20, 30, 40, 50`이면 다음과 같이 계산합니다.

```text
합계 = 10 + 20 + 30 + 40 + 50 = 150
평균 = 150 / 5 = 30.00
```

핵심 어셈블리 명령어는 다음과 같습니다.

| 명령어 | 역할 |
| --- | --- |
| `mov` | 정수와 합계 값을 레지스터/메모리로 이동 |
| `cdq` | 입력된 부호 있는 32비트 정수를 64비트 값으로 부호 확장 |
| `add`, `adc` | 부호 있는 정수 합계를 64비트로 누적 |
| `fild` | 64비트 정수 합계를 부동소수점 레지스터에 적재 |
| `fidiv` | 합계를 정수 5로 나눠 평균 계산 |
| `fstp` | 계산한 평균을 실수 변수에 저장 |
| `printf`, `scanf` | 화면 출력과 정수 입력 처리 |

## 참고 사항

- 입력은 **부호 있는 32비트 정수** 범위를 기준으로 합니다: `-2147483648`부터 `2147483647`까지.
- 평균의 출력 형식은 소수점 둘째 자리까지이며, `printf`의 `%.2f`가 표시 자릿수를 처리합니다.
- `average.exe`는 빌드하면 자동 생성되는 파일이므로 GitHub에는 `average.asm`과 `README.md`, `run.bat`, `images/execution.png`만 올려도 됩니다.
