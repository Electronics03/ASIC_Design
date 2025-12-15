## 1. 프로젝트 성격 및 기본 원칙

* **개인 프로젝트다**

  * 팀 프로젝트 아님
  * 코드 공유·복사 적발 시 **프로젝트 0점 + 최종 성적 -10점**
* **자동 채점 기반**

  * 타이밍, 신호 값, 출력 형식이 정확히 맞아야 한다
  * "의도는 맞음" 같은 변명은 인정 안 된다
* **슬라이드·공지·강의에서 말한 조건을 그대로 지켜야 한다**

  * 안 지키면 감점 또는 0점이다


## 2. 프로젝트 목표

* 16×16 **고정 크기 행렬 곱셈**을 수행하는 ASIC 설계
* 연산 대상

  * 입력: Matrix A (16×16), Matrix B (16×16)
  * 출력: Matrix O = A × B (16×16)
* **SRAM 인터페이스를 통해 ASIC과 통신**

  * CPU / FPGA가 SRAM처럼 ASIC을 접근한다고 가정


## 3. 제출 조건 (매우 중요)

* **제출 기한**

  * 12월 17일 23:59 (1초라도 늦으면 0점)
* **제출 방식**

  * E-class
* **제출 파일**

  * `{StudentID}_{Name}.zip`
  * 포함:

    * `custom_matmul16x16.sv` (필수)
    * 본인이 추가로 작성한 Verilog/SystemVerilog 파일
  * **포함하면 안 되는 것**

    * `tb_mm.sv`
    * `sram_16x1_128.sv`
    * `sram_32x1_256.sv`


## 4. 절대 금지 사항

### (1) Verilog 문법 관련

* `initial` 사용 금지 (tester 제외)
* `#delay` 사용 금지 (tester 제외)
* `readmemh`, `readmemb` 사용 금지 (tester 제외)
* 비동기 조합 회로로 전체 설계 금지

→ **모든 연산은 클럭 기반 동기식 설계**로 해라.

### (2) 템플릿 수정 관련

* SRAM 파일 수정 금지
* `custom_matmul16x16` 모듈명 변경 금지
* 포트 이름/폭 변경 금지
* tb_mm.sv 수정 금지

> 교수 말 그대로:
> "이름 바꾸면 컴파일 안 되면 그냥 0점이다. 봐줄 생각 없다."


## 5. Top Module: `custom_matmul16x16`

### 입력 포트

* `i_clk` : clock
* `i_rstn` : active-low reset (기본값 1)
* `i_cen`, `i_wen`, `i_addr[8:0]`, `i_din[31:0]`

  * **SRAM 인터페이스**
* `i_matmul_en`

  * **1클럭 pulse**
* `i_fl[2:0]`

  * fraction length (0~7)

### 출력 포트

* `o_dout[31:0]`

  * SRAM 읽기 결과
  * **SRAM 인터페이스 미사용 시 반드시 0**
* `o_done`

  * 기본값 1
  * 연산 중 0
  * 완료 후 다시 1


## 6. SRAM 인터페이스 규칙 (핵심 감점 포인트)

### 기본 SRAM 동작

| CEN | WEN | 동작      |
| | |- |
| 0   | 0   | Write   |
| 0   | 1   | Read    |
| 1   | X   | Disable |

* **CEN=1이면 SRAM은 완전히 비활성**
* 이때 `o_dout`은 **무조건 0이어야 한다**


## 7. 메모리 구조 및 주소 맵

ASIC 전체는 **하나의 큰 SRAM처럼 동작**해야 한다.

### 주소 상위 비트(`i_addr[8:7]`)로 메모리 구분

| i_addr      | 의미            |
|-- |- |
| `00xxxxxxx` | Matrix A SRAM |
| `01xxxxxxx` | Matrix B SRAM |
| `1xxxxxxxx` | Matrix O SRAM |


## 8. 데이터 포맷

### Matrix A / B

* **8-bit signed fixed-point**
* 2’s complement
* fraction length = `i_fl`
* SRAM에는 **16-bit word**

  * `{상위 8b, 하위 8b} = {a(2i+1), a(2i)}`

**읽을 때 주의**

* `o_dout[31:16]`는 **반드시 0**
* garbage / X 나오면 감점


### Matrix O

* **32-bit signed fixed-point**
* SRAM: `sram_32x1_256`
* 주소 0~255 → o0 ~ o255


## 9. 행렬 곱셈 순서

* 출력 저장 순서:

  ```
  o0, o1, ..., o15,
  o16, o17, ..., o31,
  ...
  o240 ~ o255
  ```
* 즉,

  * **row-major**
  * 한 행의 16개 열을 다 쓰고 다음 행


## 10. Fraction Length 처리 (중요)

* A, B, O **모두 같은 fraction length**
* 곱셈 후:
    * **LSB를 단순 truncation**
    * rounding 금지
* `i_fl = 0`이면 truncation 없음


## 11. 테스트 시나리오 (채점 흐름)

### 시나리오 0: Reset

* tester에서 reset **1번만**
* `i_rstn = 0 -> 1`


### 시나리오 1: Write

* tester → ASIC
* SRAM 인터페이스로 A, B 데이터 write


### 시나리오 2: Read-back (Loopback Test)

* 쓴 데이터 다시 읽어서 확인
* A/B 읽을 때:

  * MSB 16bit = 0
* 틀리면 **즉시 감점**


### 시나리오 3: Matrix Multiplication

* `i_matmul_en = 1` (1클럭)
* `o_done: 1 -> 0 -> 1`
* 결과를 OMEM에 저장


### 시나리오 4: Fraction Length Test

* `i_fl != 0`
* truncation 결과 정확히 맞아야 함


## 12. 가산점 조건

* **+2점**
  * 매 클럭마다 AMEM/ BMEM 읽어서 연산
* **+5점**

  * multiplier–adder 사이 파이프라인 삽입
  * 매 클럭 연산 유지

(기능이 먼저다. 가산점은 선택 사항이다.)


## 13. 교수 음성 기준 핵심 경고 요약

* "이건 친절한 프로젝트가 아니다"
* "이름 틀리면 그냥 0점"
* "SRAM 안 쓸 때 dout이 0 아니면 감점"
* "MSB에 쓰레기 값 있으면 감점"
* "자동 채점이라 봐줄 수 없다"


## 14. 한 줄 요약

> **ASIC을 하나의 큰 SRAM처럼 보이게 만들고,
> 정확한 주소 디코딩 + 정확한 타이밍 + 정확한 비트 포맷을 지켜
> 16×16 행렬 곱셈을 동기식으로 수행해라.**
