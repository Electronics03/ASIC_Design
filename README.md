# INT8 16×16 Matrix-Multiplication ASIC

## 1 Project Goal

- The ASIC performs fixed-size 16×16 matrix multiplication.
- Inputs: `A(16×16)`, `B(16×16)`
- Output: `O = A × B (16×16)`
- Assume an external CPU accesses the ASIC like an SRAM (communication via an SRAM-style interface).


## 2 Top Module: `custom_matmul16x16`

### Input Ports

- `i_clk`: clock
- `i_rstn`: active-low reset (default 1)
- SRAM interface
  - `i_cen`, `i_wen`, `i_addr[8:0]`, `i_din[31:0]`
- `i_matmul_en`: 1-cycle pulse (operation trigger)
- `i_fl[2:0]`: fraction length (0~7)

### Output Ports

- `o_dout[31:0]`
  - SRAM read data output
  - Must be 0 when the SRAM interface is not used
- `o_done`
  - Default is 1
  - Becomes 0 during computation
  - Returns to 1 after completion


## 3 SRAM Interface Rules (Key Grading/Deduction Points)

### Operation Definition

| CEN | WEN | Operation |
|:|:| |
|   0 |   0 | Write |
|   0 |   1 | Read  |
|   1 |   X | Disable |

- If `CEN=1`, the SRAM is inactive (Disabled).
- If behavior/output is ambiguous in Disable mode, points may be deducted -> it is safer to keep `o_dout = 0` in such cases.


## 4 Memory Structure and Address Map

The entire ASIC must behave like one large SRAM.

### Memory Region Selection by Upper Address Bits (`i_addr[8:7]`)

| Upper bits of `i_addr` | Meaning |
| | |
| `00xxxxxxx` | Matrix A SRAM |
| `01xxxxxxx` | Matrix B SRAM |
| `1xxxxxxxx`  | Matrix O SRAM |


## 5 Data Format

### (1) Matrix A / B Format

- 8-bit signed fixed-point, 2’s complement
- fraction length = `i_fl` (same for A and B)
- Stored in SRAM as 16-bit words
  - `{upper 8b, lower 8b} = {a(2i+1), a(2i)}`
  - i.e., two 8-bit elements are packed into one address.

#### A/B Read Deduction Point

- When reading A/B, `o_dout[31:16]` must be 0
- If the upper 16 bits output X/garbage, points may be deducted -> explicitly drive them to 0.

### (2) Matrix O Format

- 32-bit signed fixed-point
- SRAM: `sram_32x1_256`
- Address `0~255` maps to `o0~o255`


## 6 Output Storage Order (Row-major)

The output matrix `O` must be written to OMEM in the following order:

- `o0, o1, ..., o15`
- `o16, o17, ..., o31`
- …
- `o240 ~ o255`
- Fill all 16 columns of one row, then proceed to the next row.


## 7 Fraction Length Handling Rules

- A, B, and O all use the same fraction length (`i_fl`).
- Post-multiplication scaling:
  - If `i_fl = 0`, no shift/truncation is applied.
  - If `i_fl != 0`, perform simple LSB truncation.


## 8 Test Scenarios (Tester Flow)

### Scenario 0: Reset

- Reset is applied only once
- `i_rstn: 0 -> 1`

### Scenario 1: Write

- Write A/B data via the SRAM interface

### Scenario 2: Read-back

- Read back the recently written A/B data for verification
- For A/B reads, `o_dout[31:16] = 0`

### Scenario 3: Matrix Multiplication

- Apply `i_matmul_en = 1` as a 1-cycle pulse
- `o_done` transitions as `1 -> 0 -> 1`
- Store the result in OMEM (Matrix O)

### Scenario 4: Fraction Length Test

- Under `i_fl != 0`, the truncation result must be exactly correct

---

# Korean Version: INT8 16×16 고정 행렬곱 ASIC

## 1 프로젝트 목표

* ASIC이 16×16 고정 크기 행렬 곱셈 수행
* 입력: `A(16×16)`, `B(16×16)`
* 출력: `O = A × B (16×16)`
* 외부(CPU/FPGA)가 ASIC을 SRAM처럼 접근한다고 가정 (SRAM 인터페이스로 통신)


## 2 Top Module: `custom_matmul16x16`

### 입력 포트

* `i_clk`: clock
* `i_rstn`: active-low reset (기본 1)
* SRAM 인터페이스
  * `i_cen`, `i_wen`, `i_addr[8:0]`, `i_din[31:0]`
* `i_matmul_en`: 1클럭 pulse (연산 트리거)
* `i_fl[2:0]`: fraction length (0~7)

### 출력 포트

* `o_dout[31:0]`

  * SRAM read 결과
  * SRAM 인터페이스 미사용 시 반드시 0
* `o_done`

  * 기본값 1
  * 연산 중 0
  * 완료 후 다시 1


## 3 SRAM 인터페이스 규칙 (핵심 감점 포인트)

### 동작 정의

| CEN | WEN | 동작      |
| --: | --: |- |
|   0 |   0 | Write   |
|   0 |   1 | Read    |
|   1 |   X | Disable |

* `CEN=1`이면 SRAM 비활성(Disable) 상태다.
* Disable일 때 출력/동작이 애매하면 감점 위험 -> o_dout=0 같은 안전 동작을 유지하는 쪽이 유리하다.


## 4 메모리 구조 및 주소 맵

ASIC 전체는 하나의 큰 SRAM처럼 동작해야 한다.

### 상위 주소 비트로 A/B/O 영역 구분 (`i_addr[8:7]`)

| i_addr 상위   | 의미            |
|-- |- |
| `00xxxxxxx` | Matrix A SRAM |
| `01xxxxxxx` | Matrix B SRAM |
| `1xxxxxxxx` | Matrix O SRAM |


## 5 데이터 포맷

### (1) Matrix A / B 포맷

* 8-bit signed fixed-point, 2’s complement
* fraction length = `i_fl` (A, B 동일)
* SRAM에는 16-bit word 단위 저장
  * `{상위 8b, 하위 8b} = {a(2i+1), a(2i)}`
  * 즉, 한 주소에 8비트 값 2개가 packed 된다.

#### A/B 읽기 감점 포인트

* A/B read 시 `o_dout[31:16]`는 반드시 0
* 상위 16비트가 X/garbage로 나오면 감점 -> 명시적으로 0으로 drive해야 한다.

### (2) Matrix O 포맷

* 32-bit signed fixed-point
* SRAM: `sram_32x1_256`
* 주소 `0~255`가 `o0~o255`에 대응


## 6 행렬곱 결과 저장 순서 (Row-major)

출력 `O`를 OMEM에 아래 순서로 저장해야 한다.

* `o0, o1, ..., o15`
* `o16, o17, ..., o31`
* …
* `o240 ~ o255`
* 한 행(16개 열)을 다 채운 뒤 다음 행으로 진행한다.


## 7 Fraction Length 처리 규칙

* A, B, O 모두 같은 fraction length(i_fl)를 사용한다.
* 곱셈 후 스케일 처리:

  * `i_fl = 0`이면 shift/truncation 없음
  * `i_fl != 0`이면 LSB를 단순 truncation한다.


## 8 테스트 시나리오 (테스터 동작 흐름)

### 시나리오 0: Reset

* reset은 1번만
* `i_rstn: 0 -> 1`

### 시나리오 1: Write

* SRAM 인터페이스로 A/B 데이터 write

### 시나리오 2: Read-back

* 방금 쓴 A/B를 read해서 검증
* 이때 A/B read는 `o_dout[31:16] = 0`


### 시나리오 3: Matrix Multiplication

* `i_matmul_en = 1`을 1클럭 pulse로 입력
* `o_done: 1 -> 0 -> 1`로 동작
* 결과를 OMEM(Matrix O)에 저장

### 시나리오 4: Fraction Length Test

* `i_fl != 0` 조건에서 truncation 결과가 정확해야 한다.

---

## Final Exam Explanation
### [06. Arithmetic](./02_Final/06_Arithematic/06_Arithematic.md)
### [07. FP and FXP](./02_Final/07_FXPFP/07_FXPFP.md)
### [08. FSM](./02_Final/08_FSM/08_FSM.md)
### [09. Memory](./02_Final/09_Memory/09_Memory.md)
### [10. TIming Constraint](./02_Final/10_Timing_Constraint/10_Timing_Constraint.md)
### [11. Power](./02_Final/11_Power/11_Power.md)