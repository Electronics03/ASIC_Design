# 이진수 표현 (Binary Number Representation)

## 수 체계와 포맷 (Number Systems and Formats)

### 10진수 → 2진수 변환 (Decimal to Binary Conversion)

* 10진수는 **기수 10**을 사용한다 (10의 거듭제곱).
* 2진수는 **기수 2**를 사용한다 (2의 거듭제곱).
* 예시:

$$
1234_{10} = 1\times2^{10} + 0\times2^{9} + 0\times2^{8} + 1\times2^{7} + 1\times2^{6} + 0\times2^{5} + 1\times2^{4} + 0\times2^{3} + 0\times2^{2} + 1\times2^{1} + 0\times2^{0}
$$

* 필요한 최소 비트 폭 = 가장 큰 2의 거듭제곱 위치
* **MSB (Most Significant Bit)**: 가장 큰 값을 나타내는 비트
* **LSB (Least Significant Bit)**: 가장 작은 값을 나타내는 비트


## 16진수 표현 (Hexadecimal Representation)

* **기수 16** 수 체계 (0–9, A–F는 10–15를 의미)
* 이진수 표현에 효율적:

  * **이진수 4비트 = 16진수 1자리**
* 장점:

  * 이진 표기 대비 파일 크기를 약 **25% 감소**
* “16진수에서는 한 자리로 0부터 15까지 표현 가능”
* 변환 방법:

  * 이진수를 4비트씩 묶어서 각 그룹을 16진수로 변환
* 예시:

```
10011010010₂
= 0100 1101 0010₂
= 4D2₁₆
```


## Verilog에서의 수 표현

* 10진수: `11'd1234`
* 2진수: `11'b10011010010`
* 16진수: `11'h4D2`


## 부호 없는 정수 표현 (Unsigned Integer Representation)

* 양의 정수만 표현
* 모든 비트가 크기(magnitude)에 기여
* 예:

  * 4비트 unsigned → 0 ~ 15 (총 16개 값)


## 부호 있는 정수 표현 (Signed Integer Representation)

### 부호-크기(Sign-Magnitude) 방식

* MSB가 부호:

  * 0 = 양수
  * 1 = 음수
* 나머지 비트는 크기
* 예시:

  * +23₁₀ = `010111₂`
  * −23₁₀ = `110111₂`
* 단점:

  * +0과 −0이 모두 존재 (표현 낭비)
  * 표현 범위가 비대칭
  * 뺄셈 회로 구현에 비효율적


### 2의 보수 (Two’s Complement)

* MSB는 $-2^{n-1}$의 가중치를 가진다
* 디지털 시스템에서 **표준적인 부호 표현 방식**
* n비트일 때 표현 범위:

  * $(-2^{n-1}) \sim (+2^{n-1}-1)$
* 예시: 6비트에서 −23₁₀ 표현

  1. 크기: 23 = `010111₂`
  2. 비트 반전: `101000₂`
  3. +1: `101001₂`
* 검증:

  * −32 + 8 + 1 = −23 ✓


### 2의 보수 변환 절차

1. 전체 비트 폭 결정
2. 절댓값(|x|)을 이진수로 표현
3. 모든 비트를 반전
4. 1을 더함

> “모든 비트를 반전하고 1을 더하는 것이 전체 변환 과정이다.”


## 부호 확장 (Sign Extension)

* 목적:

  * 값은 유지하면서 비트 폭을 확장
* 2의 보수 방식:

  * MSB를 왼쪽 새 비트에 그대로 복사
* 예시:

  * −1 (4비트) = `1111₂`
  * 8비트 확장 → `11111111₂`
* 서로 동일한 값
* **서로 다른 비트 폭 연산에서 필수**


# 산술 회로 (Arithmetic Circuits)

## 덧셈 회로 (Addition Circuits)

### 하프 애더 (Half Adder)

* 정의:

  * 캐리 입력 없이 두 개의 1비트 이진수를 더하는 논리 회로
* 입력: a, b
* 출력: s (합), c (캐리)
* 진리표:

  * 0+0 = 00
  * 0+1 = 01
  * 1+0 = 01
  * 1+1 = 10
* 구현:

  * s = a XOR b
  * c = a AND b

```verilog
module HalfAdder (
  input wire a, b,
  output wire c, s
);
  assign s = a ^ b;
  assign c = a & b;
endmodule
```


### 풀 애더 (Full Adder)

* 정의:

  * 캐리 입력(cin)을 포함한 덧셈 회로
* 입력: a, b, cin
* 출력: s, cout
* 특징:

  * 입력 중 홀수 개가 1이면 s = 1
  * 두 개 이상이 1이면 cout = 1
* 하프 애더로 구현 가능:

  * HA1: a + b → g, p
  * HA2: cin + p → s, cp
  * cout = g OR cp

```verilog
module FullAdder1 (
  input wire a, b, cin,
  output wire cout, s
);
  wire g, p, cp;
  HalfAdder ha1(a, b, g, p);
  HalfAdder ha2(cin, p, cp, s);
  assign cout = g | cp;
endmodule
```


### 다비트 덧셈 (Multi-bit Addition)

* 여러 개의 Full Adder를 직렬 연결
* 캐리는 LSB → MSB 방향으로 전파
* LSB는 cin = 0이므로 Half Adder 사용 가능
* 오버플로우:

  * n비트 + n비트 → (n+1)비트 필요

```verilog
module Adder1 #(parameter n = 8) (
  input wire [n-1:0] a, b,
  input wire cin,
  output wire [n-1:0] s,
  output wire cout
);
  assign {cout, s} = a + b + cin;
endmodule
```


## 뺄셈 구현 (Subtraction)

### 2의 보수를 이용한 방법

* 핵심 아이디어:
  $$
  A - B = A + (-B)
  $$
* B를 2의 보수로 바꾼 뒤 덧셈 수행
* XOR로 비트 반전 + 1 더하기


### 가감산기 (Adder/Subtractor)

* 하나의 회로로 덧셈/뺄셈 수행
* 제어 신호:

  * sub = 0 → 덧셈
  * sub = 1 → 뺄셈
* 오버플로우 검출:

  * `c1 XOR c2`

```verilog
module AddSub1 #(parameter n = 8) (
  input wire [n-1:0] a, b,
  input wire sub,
  output wire [n-1:0] s,
  output wire ovf
);
  wire c1, c2;
  assign ovf = c1 ^ c2;
  assign {c1, s[n-2:0]} = a[n-2:0] + (b[n-2:0] ^ {(n-1){sub}}) + sub;
  assign {c2, s[n-1]} = a[n-1] + (b[n-1] ^ sub) + c1;
endmodule
```


## 오버플로우 (Overflow)

### 정의

* 결과가 표현 가능한 범위를 초과할 때 발생

### 예시

```
4비트: 0111 (7) + 0111 (7) = 1110 (-2)
```

### 검출 방법

* 2의 보수:

  * MSB 캐리와 그 이전 캐리 비교
  * overflow = c1 XOR c2
* unsigned:

  * MSB 캐리 발생 여부 확인

### 예방

* 부호 확장
* 출력 비트를 n+1비트로 선언

> “오버플로우를 방지하기 위해 1비트를 추가한다.”


## 비교기 (Comparator)

### 뺄셈 기반 비교

* diff = a − b
* diff < 0 → a < b
* diff = 0 → a = b
* diff > 0 → a > b


# 곱셈 (Multiplication)

## 부호 없는 정수 곱셈

### 기본 원리

* 부분 곱 생성
* 위치에 따라 시프트
* 모든 부분 곱을 더함
* n비트 × n비트 → 2n비트 결과

### 하드웨어 복잡도

* 부분 곱: AND 게이트
* 결합: Full Adder
* 4×4 → 12 Full Adder
* n×n → n(n−1) Full Adder


### Verilog 예제

```verilog
assign p = $unsigned(a) * $unsigned(b);
```


## 부호 있는 곱셈 (2의 보수)

* 음수 처리로 복잡도 증가
* 마지막 부분 곱에서 부호 확장 필요
* NAND 게이트 사용으로 하드웨어 절감
* Full Adder 수는 거의 동일
* Half Adder 1개 추가 정도


# 나눗셈 (Division)

## 부호 없는 정수 나눗셈

### 절차

1. 비교
2. 가능하면 뺄셈
3. 몫 비트 결정
4. 반복

### 특징

* 순차적 연산 (병렬화 불가)
* 지연 큼
* 면적/전력 소모 큼

### 권장 사항

> “나눗셈 회로는 피하라.”

* 대안:

  * 역수 곱셈
  * 2의 거듭제곱 나눗셈 → 시프트


# 실무 설계 고려사항

## 비트 폭 관리

* 흔한 실수: 출력 비트 부족
* n비트 + n비트 → (n+1)비트 필요


## 최적화 전략

1. cin=0이면 Half Adder 사용
2. 2의 거듭제곱은 시프트
3. 나눗셈 대신 역수 곱
4. 복잡한 연산 최소화
5. 병렬 연산 극대화


## Verilog 모범 사례

* `+`, `-` 연산자 사용
* 합성 도구에 최적화 위임
* 명확한 비트 폭 선언
* 테스트벤치 작성 필수