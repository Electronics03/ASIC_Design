# 회로 설계에서의 전력 기초 (Power Fundamentals in Circuit Design)

## 개요 (Overview)

* 전력은 회로 설계에서 면적(area), 속도(speed)와 함께 세 가지 주요 지배 요소 중 하나이다.
* 특히 현대의 모바일 및 배터리 기반 장치(스마트폰, 스마트워치, 태블릿, 노트북)에서 매우 중요하다.
* AC 전원에 연결할 수 있는 데스크톱 시스템과 달리, 모바일 장치는 제한된 배터리 용량에 의존한다.
* 열 발생은 전력 소비와 직접적으로 관련된다: 전력이 클수록 열 발생도 증가한다.

## 전력과 에너지 개념 (Power vs. Energy Concepts)

* 전력(Power)

  * 단위 시간당 소비되는 에너지
  * 일반적으로 1초 기준으로 측정됨
  * 단위: 와트(W) = 줄/초(J/s)
  * 에너지 사용 속도의 순간적인 측정값

* 에너지(Energy)

  * 일정 시간 동안 소비된 총 에너지
  * 단위: 줄(J) 또는 와트시(Wh)
  * 계산식:
    $$
    \text{Energy} = \text{Power} \times \text{Time}
    $$

* 실용적인 예:

  * 1킬로와트(kW)를 1초 동안 사용하면 -> 1,000줄(J)

* 전력의 의미:

  * “전력이란, 단위 시간(1초) 동안 얼마만큼의 에너지가 소비되는가를 의미한다.”

## 전력과 배터리 수명의 관계 (Relationship Between Power and Battery Lifetime)

* 배터리 수명은 다음으로 결정된다:
  $$
  \text{배터리 저장 에너지} \div \text{전력 소비율}
  $$

* 예시:

  * 배터리에 1,000J가 저장되어 있고 장치가 1,000J/s를 소비하면 -> 1초만 동작
  * 동일한 배터리가 1mW를 소비하는 장치를 구동하면 -> 1,000,000초 동작

* 배터리 수명을 늘리는 두 가지 방법:

  1. 배터리 용량 증가 (직관적이지만 한계 존재)
  2. 전력 소비 최소화 (장기적으로 더 효과적)

## 전력 계산의 기초 (Power Calculation Fundamentals)

* 기본 식:
  $$
  P = V \times I
  $$
* 장치가 동작하는 동안 연속적으로 측정됨
* 현대 시스템에서는 전압 레귤레이터 내부의 전력 측정 회로가 전압과 전류를 모두 측정하여 전력을 추정함

## 회로 소자에서의 전력 (Power in Circuit Elements)

### 저항 (Resistors)

* 주요 역할: 전력을 소비
* 전력 소모 식:
  $$
  P = I^2R \quad \text{또는} \quad P = \frac{V^2}{R}
  $$
* 전기 에너지를 열로 변환
* 교과서 예제: 저항을 흐르는 전력은 $P = V \times I$

### 커패시터 (Capacitors)

* 주요 역할: 전하와 에너지를 저장 (전력 소비 X)
* 저장 에너지:
  $$
  E = \frac{1}{2}CV^2
  $$
* 전압 (V_{DD})로 완전히 충전된 커패시터는:
  $$
  \frac{1}{2}C_LV_{DD}^2
  $$
* 충전 중: 전력 소비 없음 (전하 축적만 발생)
* 충전된 후 스위치/트랜지스터를 통해 방전되면 저장된 에너지는 열로 소산됨

## CMOS 로직에서 MOSFET 동작 (MOSFET Behavior in CMOS Logic)

* 게이트 커패시턴스: MOS 커패시터와 유사
* 항상 내부 저항 성분을 포함 -> 일부 전력 소모 발생
* 두 종류의 MOSFET이 상보적으로 동작:

  * pMOS (풀업): 출력 커패시터 충전
  * nMOS (풀다운): 출력 커패시터 방전

## CMOS 로직 회로 동작 (CMOS Logic Circuit Operation)

### 충·방전 사이클 (기본 전력 소모 원인)

* CMOS 전력의 대부분은 저항 손실이 아니라 충·방전 반복에서 발생

* 충전 단계

  * pMOS ON -> 전원(VDD)에서 출력 커패시터로 전류 흐름
  * 커패시터가 VDD까지 충전
  * 공급된 에너지: $\frac{1}{2}C_LV_{DD}^2$
  * 절반은 pMOS에서 열로 소산, 절반은 커패시터에 저장

* 방전 단계

  * nMOS ON -> 저장된 전하가 접지로 흐름
  * 저장 에너지 전부($\frac{1}{2}C_LV_{DD}^2$)가 nMOS에서 열로 소산

* 이 사이클이 반복됨

## 인버터 예제 (Inverter Example)

* 입력 1:

  * nMOS ON, pMOS OFF -> 출력 0, 커패시터 방전
* 입력 0:

  * nMOS OFF, pMOS ON -> 출력 1, 커패시터 충전
* 입력 전이 -> 출력 전이 직접 유발

## 쇼트 서킷 전류 (Short Circuit Current)

* 입력 전이 중 pMOS와 nMOS가 동시에 ON 되는 순간 발생
* 중간 전압(예: 0.5V) 구간에서 두 트랜지스터가 부분적으로 켜짐
* VDD -> GND로 직접 전류 흐름
* 커패시터 충전과 무관
* 전체 동적 전력의 10% 미만
* 지속 시간이 매우 짧음

## 이상적 vs 실제 전력 소모 (Ideal vs. Real)

* 이상적: 저항 없음 -> 커패시터 충전 시 전력 소모 없음
* 실제:

  * 내부 저항 존재
  * 전압 점진적 상승
  * 저항에서 전력 소산 발생

## 동적 전력 소모 (Dynamic Power Consumption)

### 정의

* 회로가 스위칭할 때 소비되는 전력
* 구성:

  1. 스위칭 전력 (~90%)
  2. 쇼트 서킷 전력 (~10%)

### 스위칭 전력 (Switching Power)

$$
P_{dynamic} = \alpha \cdot C_L \cdot V_{DD}^2 \cdot f
$$

* ($\alpha$): 활동 계수
* ($C_L$): 부하 커패시턴스
* ($V_{DD}$): 전원 전압
* ($f$): 동작 주파수

### 활동 계수 (Activity Factor)

* 클럭: $\alpha = 1$
* 매 사이클 1회 전이: $\alpha = 0.5$
* 랜덤 데이터: $\alpha = 0.25$
* 실제 회로: $\alpha \approx 0.1$

$$
\alpha_i = P_i^0 \times P_i^1
$$

## 정적 전력 (Static Power Consumption)

* 회로가 동작하지 않아도 소비되는 전력
* 누설 전류에 의해 발생
* 식:
  $$
  P_{static} = (I_{sub} + I_{gate} + I_{junction} + I_{contention}) \cdot V_{DD}
  $$

## 정적 전력 감소 기법 (Static Power Reduction Techniques)

### 파워 게이팅 (Power Gating)

* 슬립 트랜지스터로 전원 차단
* 정적 전력 완전 제거
* 상태 유지 필요

### 문턱 전압 제어 (Threshold Voltage Control)

* HVT / LVT / RVT 셀 사용
* 바디 이펙트 이용:

  * Reverse Body Bias -> $V_{th}$ 증가 -> 누설 감소
  * Forward Body Bias -> 속도 증가, 누설 증가



## 결론적 통찰 (Key Insight)

* 에너지 = 전력 × 시간
* 전력을 줄여도 시간이 늘면 에너지는 증가할 수 있다
* 전압과 주파수를 함께 낮춰야 에너지도 감소한다