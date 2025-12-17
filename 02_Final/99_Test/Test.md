# 시험 대비
## Arithmetic
### 2's Complement가 Signmagnitude보다 더 좋은 이유
- 덧셈/뺄셈 회로 단순화
- 유일한 0 표현
- 부호 비트로 인해 표현 가능한 수의 범위가 더 넓음

## FXP와 FP
### Desimal to FXP
1. 10진수 값에 $2^f$를 곱한다 (f = 소수 비트 수)
2. 결과를 가장 가까운 정수로 반올림한다
3. 해당 정수를 이진수로 변환한다
4. 오른쪽에서 f비트 위치에 소수점을 둔다

### FXP to Desimal
1. 이진수 값을 정수로 해석한다
2. 결과를 $2^{-f}$로 곱한다 (f = 소수 비트 수)

### FXP Addition/Subtraction
- 동일한 소수 비트 수를 가진 FXP 값끼리 덧셈/뺄셈을 수행한다
- 서로 다른 소수 비트 수를 가진 경우, 더 큰 쪽에 맞춰 정렬한다
- 결과의 소수 비트 수는 입력과 동일하다

### FXP Multiplication
- 두 FXP 값을 정수로 간주하고 곱한다
- 결과의 소수 비트 수 = 입력 소수 비트 수의 합
- 필요 시 다시 소수 비트를 줄여 반올림 가능

### Desimal to FP
1. 10진수 값을 이진수로 변환한다
2. 이진수 값을 정규화한다 (1.xxxx 형태)
3. 지수와 가수(Mantissa)를 추출한다
4. 지수에 바이어스를 더한다
5. 부호 비트, 지수 비트, 가수 비트를 조합하여 FP 표현을 완성한다

### FP to Desimal
1. FP 표현에서 부호 비트, 지수 비트, 가수 비트를 분리한다
2. 지수에서 바이어스를 뺀다
3. 가수에 암묵적 선행 1을 추가한다
4. 값을 계산한다: 
$$
Value = (-1)^{Sign} \times (1 + fraction) \times 2^{(Exponent - Bias)}
$$

### FP Addition/Subtraction
1. 지수 맞추기: 지수가 더 작은 수의 가수를 오른쪽으로 시프트한다
2. 가수 덧셈/뺄셈 수행
3. 결과 정규화: 필요 시 가수를 왼쪽/오른쪽으로 시프트하고 지수를 조정한다
4. 반올림 및 오버플로우 처리

### FP Multiplication
1. 부호 비트 계산: 두 수의 부호 비트를 XOR한다
2. 지수 덧셈: 두 수의 지수를 더하고 바이어스를 뺀다
3. 가수 곱셈: 두 수의 가수를 곱한다
4. 결과 정규화: 필요 시 가수를 조정하고 지수를 업데이트한다

### IEEE 754 Standard
- Half Precision (16 bits)
    - 1 bit Sign
    - 5 bits Exponent (Bias 15)
    - 10 bits Mantissa (Implicit leading 1)
- Single Precision (32 bits)
    - 1 bit Sign
    - 8 bits Exponent (Bias 127)
    - 23 bits Mantissa (Implicit leading 1)
- Double Precision (64 bits)
    - 1 bit Sign
    - 11 bits Exponent (Bias 1023)
    - 52 bits Mantissa (Implicit leading 1)

| Field       | Bits | Description                          |
|-------------|------|--------------------------------------|  
| Sign        | 1    | Indicates the sign of the number     |
| Exponent    | 8    | Encodes the exponent with a bias     |
| Mantissa    | 23   | Represents the significant digits    |

- General Form
    - `Value = (-1)^Sign × (1 + fraction) × 2^(Exponent − Bias)`
    - `Exponent = 0-254, mentissa = 0 ~ (1 - 2^-23)`

- Special Cases
    - Zero: Exponent = 0, Mantissa = 0
    - denormalized Number: Exponent = 0, Mantissa != 0
    - Floating-Point Number: Exponent = 1~254, Mantissa = any value
    - Infinity: Exponent = 255(11111111), Mantissa = 0
    - NaN: Exponent = 255(11111111), Mantissa != 0


## Timing
### Setup Time
* 셋업 타이밍 슬랙
$$
t_{\text{slack}} = t_{cy} - (t_s + t_{dab} + t_{dCQ})
$$
* $t_{cy}$: 클럭 주기
* $t_s$: 셋업 타임 (플립플롭 데이터시트)
* $t_{dab}$: 조합 논리의 전파 지연
* $t_{dCQ}$: 클럭에서 Q까지의 전파 지연
* $t_{\text{slack}} \ge 0$: 셋업 제약 만족, 동작 보장
* $t_{\text{slack}} < 0$: 셋업 위반 발생, 데이터가 충분히 일찍 도착하지 않음

### Hold Time
* 홀드 타이밍 슬랙
$$
t_{\text{slack}} = t_{cCQ} + t_{ccd} - t_h
$$
* $t_{cCQ}$: 클럭 -> Q 오염 지연
* $t_{ccd}$: 조합 논리의 오염 지연 (최소 지연)
* $t_h$: 홀드 타임
* $t_{\text{slack}} \ge 0$: 홀드 제약 만족
* $t_{\text{slack}} < 0$: 홀드 위반 발생, 데이터가 너무 빨리 변함

### Time skew
#### 셋업 타임에 대한 영향
* Prior 플립플롭 지연 시
$$
t_{\text{slack}} = t_{cy} + t_k - (t_s + t_{dab} + t_{dCQ})
$$
  * 셋업 위반 가능성 증가 (부정적)

* Posterior 플립플롭 지연 시
$$
t_{\text{slack}} = t_{cy} - t_k - (t_s + t_{dab} + t_{dCQ})
$$
  * 셋업 여유 증가 (긍정적)
* 권장: 셋업 위반 해결을 위해 후단 플립플롭에 지연 삽입

#### 홀드 타임에 대한 영향 (Effect on Hold Time Constraint)
* Prior 플립플롭 지연 시
$$
t_{\text{slack}} = t_{cCQ} + t_{ccd} - t_h - t_k
$$
  * 홀드 위반 위험 증가
* Posterior 플립플롭 지연 시
$$
t_{\text{slack}} = t_{cCQ} + t_{ccd} - t_h + t_k
$$
  * 홀드 여유 증가
* 권장: 홀드 위반 해결을 위해 전단 플립플롭에 지연 삽입
* 주의: 홀드 해결을 위한 스큐 조정은 셋업을 악화시킬 수 있다.

## Power
### Dynamic Power 결정하는 두가지 요소
- Short Circuit Current
- Switching Power

### Static Power 결정하는 네가지 요소
- Subthreshold Leakage
- Gate Leakage
- Junction Leakage
- Contention Leakage

### Dynamic Power 줄이는 방법
- Activity Factor 줄이기
    - Clock Gating
- Capacitance 줄이기
    - 트랜지스터 크기 줄이기
    - 배선 길이 줄이기
- Voltage 줄이기
    - Voltage domain 분리
    - Dynamic Voltage Scaling
- Frequency 줄이기
    - 성능 요구사항 낮추기
- Dynamic Voltage and Frequency Scaling (DVFS)
    - 작업 부하에 따라 동적으로 전압과 주파수 조절
    - 전압과 주파수를 동시에 조절하는 것을 추천

### Static Power 줄이는 방법
- 파워 게이팅 (Power Gating)
    - 사용하지 않는 블록의 전원 차단
- 문턱 전압 제어 (Threshold Voltage Control)
    - Body Effect
- Volage Domain 분리