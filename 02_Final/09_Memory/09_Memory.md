# 순차 논리 회로와 메모리 설계

(Sequential Logic Circuits and Memory Design)

## 순차 논리 회로 기초

(Sequential Logic Circuit Fundamentals)

* **순차 논리 회로(Sequential Logic Circuit)**: 조합 논리와 메모리 요소(래치)를 결합한 회로이다.
* 조합 논리 회로와의 핵심 차이점은 논리 단계 사이에 **래치 또는 메모리 요소**가 삽입된다는 점이다.
* 대표적인 예: 메모리 요소로 **D 플립플롭**을 사용하는 구조
* **유한 상태 머신(Finite State Machine, FSM)**:

  * 상태(state), 상태에 따른 출력, 상태 전이를 정의하여 회로의 동작을 표현
  * 상태 다이어그램(state diagram)을 사용
* 디지털 회로의 컨트롤러 설계에서 매우 중요하며, **상태 다이어그램 설계의 품질이 회로 복잡도와 구현 난이도에 큰 영향을 미친다.**


## 기본 메모리로서의 레지스터

(Register as Basic Memory)

### 레지스터의 정의와 특성

(Register Definition and Characteristics)

* 여러 개의 D 플립플롭을 사용하여 1비트 이상의 데이터를 저장
* 분류:

  * 모든 메모리 유형 중 **가장 빠른 읽기/쓰기 속도**를 가지는 원형(기본) 메모리
* 조합 논리 대비:

  * 더 큰 면적과 더 많은 전력 소모 필요
* 다른 메모리 유형 대비:

  * 더 큰 면적을 차지하지만, **전력 소모는 더 작다**


### 기능적 레지스터 예시

(Functional Register Examples)

* **카운터(Counter)**:

  * 매 클록마다 1씩 증가하는 N비트 레지스터
* **업/다운 카운터(Up/Down Counter)**:

  * 증가기와 감소기를 모두 포함
  * 방향 제어 신호 포함
* **로드 기능이 있는 카운터(Counter with Load)**:

  * 외부 값 로드 가능
  * 로드가 카운트보다 우선순위 높음
* **시프트 레지스터(Shift Register)**:

  * 직렬 입력–직렬 출력: 비트를 한 칸 이동시키며 0을 삽입
  * 병렬 입력–병렬 출력: 병렬 입력/출력 가능
  * 시프트 유지 선택을 위해 **2:1 멀티플렉서** 사용


## 레지스터 파일: 다중 레지스터 구성

(Register File: Organizing Multiple Registers)

### 개념

(Concept)

* 여러 개의 레지스터를 메모리처럼 조직한 구조
* 여러 저장 값에 대해 선택적 읽기/쓰기 가능
* 클록 및 제어 신호 공유:

  * 쓰기 인에이블
  * 주소
  * 칩 인에이블


### 구조

(Architecture)

* 주소 디코딩과 데이터 선택을 위해 디코더와 멀티플렉서 사용
* 주소(Address): 접근할 레지스터 지정
* 쓰기 인에이블(Write Enable): 쓰기 여부 제어
* 로드 신호(Load Signal): 새 데이터와 기존 값 선택
* 각 레지스터 위치는 고유한 주소 조합에 대응


### 제어 신호

(Control Signals)

* 주소 핀: 특정 레지스터 위치 선택
* 쓰기 인에이블: 쓰기 동작 활성화
* 데이터 입력: 저장할 새 데이터
* 데이터 출력: 선택된 레지스터의 읽기 데이터
* 로드 신호:

  * Low: 값 유지
  * High: 새 값 기록


## 메모리 어레이 구조

(Memory Array Architecture)

### 구조

(Structure)

* 메모리 셀을 2차원 또는 다차원 배열로 결합
* 행 디코더(Row Decoder): 행 주소 비트로 특정 행 활성화
* 열 디코더(Column Decoder): 열 주소 비트로 특정 열 활성화
* 활성화된 행과 열의 교차점에서 단일 셀 접근
* 데이터 폭: 열의 개수(워드당 비트 수)로 결정
* 워드 수: 행 디코더 수로 결정 (주소 비트 (2^n))


### 접근 메커니즘

(Access Mechanism)

* 주소를 행과 열 부분으로 분리
* 한 시점에 하나의 행–열 교차점만 활성화
* 선택된 셀에서 데이터 읽기 또는 쓰기
* 주소 공간을 접어(folding) 단일 레지스터 파일보다 높은 셀 밀도 달성


## 동기 신호와 비동기 신호

(Synchronous vs Asynchronous Signals)

### 클리어/리셋 동작

(Clear/Reset Operations)

* **동기 클리어(Synchronous Clear)**:

  * 클록의 양의 에지에서만 활성화
  * 클록 신호에 의존
  * 컨트롤러 또는 FSM 내부에서 생성되는 리셋에 사용
  * 제어되고 동기화된 리셋 제공

* **비동기 클리어(Asynchronous Clear)**:

  * 클록과 무관하게 동작
  * 감지 즉시 활성화
  * 타이밍이 예측 불가능한 물리적 버튼 리셋에 사용
  * 클록 동기화 없이 에지 전이 감지


### 구현 고려 사항

(Implementation Considerations)

* 비동기 설계는 여러 양의 에지를 동시에 감지하는 것을 피한다 (구현이 더 어렵기 때문).
* 대신 하나의 양의 에지와 하나의 음의 에지를 감지하여 구분한다.
* 하드웨어 리셋 회로 및 비상 정지 메커니즘에서 일반적으로 사용된다.


## 블로킹 대 논블로킹 할당

(Blocking vs Non-Blocking Assignment)

### 개념적 차이

(Conceptual Difference)

* **블로킹 할당(=)**:

  * 명령이 순차적으로 실행됨
  * 각 문장은 이전 결과에 의존
  * 병렬 계산 불가
  * 논리적 실행 순서 생성

* **논블로킹 할당(<=)**:

  * 명령이 동시에 실행됨
  * 모든 문장이 동일한 클록 에지에서 반영
  * 병렬 계산 가능
  * 파이프라인 구조에 유용


### 실질적 의미

(Practical Implications)

* 블로킹 예:

  * Q1 ← 입력 -> Q2 ← Q1 -> 출력 ← Q2 (순차 전파)
* 논블로킹 예:

  * 모든 레지스터가 클록 에지에서 동시에 입력을 받음
* 논블로킹은 파이프라인 구조를 가능하게 함:

  * 데이터가 매 클록마다 단계적으로 이동

> “때로는 이러한 논블로킹 할당이 파이프라인 구조를 만드는 데 유용하다. 클록을 사용해 전파를 동기화함으로써 값을 누적할 수 있다.”


### 설계 권장 사항

(Design Recommendations)

* 조합 논리(always 사용): **블로킹 할당** 사용
* 순차 논리: **논블로킹 할당** 사용
* 파이프라인 구조는 논블로킹 할당으로 자연스럽게 구현됨


## 메모리 기초

(Memory Fundamentals)

### 컴퓨팅 시스템 구조

(Computing System Architecture)

* 두 가지 핵심 요소:

  1. 연산 논리: 프로세서(CPU, GPU, AP)
  2. 저장 장치: 메모리(DRAM, SSD, HDD)
* 프로세서 내부:

  * 연산 유닛(ALU, MAC)
  * 메모리(레지스터, SRAM)


### 메모리 요구 사항

(Memory Requirements)

* 요구 사항 1:

  * 전기적으로 구분 가능한 두 상태 필요
  * 높은 전압(VDD): 논리 1
  * 낮은 전압(GND): 논리 0
* 요구 사항 2:

  * 세 가지 동작 지원

    * 유지(Hold)
    * 쓰기(Write)
    * 읽기(Read)


### 데이터 표현

(Data Representation)

* 메모리는 이진 데이터(0과 1)로 정보 저장
* 단일 비트를 다중 비트 문자열로 확장 가능
* 전압 레벨을 통해 전기적으로 구현 가능


## 온칩 메모리 분류

(On-Chip Memory Classifications)

### 위치 기준

(By Location)

* 온칩 메모리:

  * 프로세서 내부
  * 레지스터, SRAM
  * 빠른 접근, 제한된 용량
* 오프칩 메모리:

  * 프로세서 외부
  * DRAM, SSD, HDD, CD, USB, 네트워크 스토리지


### 접근 방식 기준

(By Access Pattern)

* 랜덤 접근 메모리(RAM):

  * 주소와 무관하게 일정 시간 내 접근
  * 레지스터 파일, SRAM, DRAM
* 직렬 접근 메모리:

  * 순차 접근 필요
  * 메인 컴퓨팅에는 드묾


### 읽기/쓰기 기준

(By Read/Write Capability)

* RAM:

  * 읽기/쓰기 가능
  * SRAM, DRAM, 레지스터
* ROM:

  * 읽기 전용
  * 제조 시 데이터 저장 (예: CD-ROM)


## 메모리 계층과 성능 트레이드오프

(Memory Hierarchy and Performance Trade-offs)

### 속도 대 밀도 삼각형

(Speed vs Density Triangle)

* 레지스터:

  * 가장 빠름 (0.25~0.5ns)
  * 가장 낮은 밀도
  * 비트당 전력 소모 최대
* SRAM:

  * 빠름 (0.5~25ns)
  * 중간 밀도
* DRAM:

  * 중간 속도 (80~250ns)
  * 높은 밀도
* SSD/HDD:

  * 가장 느림
  * 가장 높은 밀도
  * 비휘발성


### 휘발성 분류

(Volatility Classification)

* 휘발성 메모리:

  * 전원 OFF 시 데이터 소실
  * 빠른 접근
* 비휘발성 메모리:

  * 전원 없어도 데이터 유지
  * 느린 접근


## 캐시 계층

(Cache Hierarchy)

* L1 캐시: 온칩, 레지스터급 속도
* L2 캐시: 온칩 SRAM
* 메인 메모리: DRAM
* 보조 저장장치: SSD/HDD

> “최고의 접근 속도를 확보하면, 확실성을 잃게 된다. 이것이 메모리 아키텍처의 슬픔이다.”


## SRAM (정적 랜덤 접근 메모리)

### 6T SRAM 셀 구조

(6T SRAM Cell Structure)

* 6개의 트랜지스터로 구성
* 교차 결합 인버터가 핵심
* 두 노드: A와 A_b
* 워드라인으로 제어되는 접근 트랜지스터
* 상보적인 비트라인 사용


### 데이터 저장 메커니즘

(Data Storage Mechanism)

* 교차 결합 인버터의 양의 피드백으로 데이터 유지
* 전원 공급되는 한 데이터 유지


### 읽기 동작

(Read Operation)

1. 비트라인을 1로 프리차지
2. 워드라인 활성화
3. 한 비트라인이 GND로 당겨짐
4. 전압 차 발생
5. 센스 앰프가 증폭


### 쓰기 동작

(Write Operation)

1. 비트라인에 상보 데이터 인가
2. 워드라인 활성화
3. 강한 드라이버가 기존 상태 덮어씀


### SRAM 장단점

(SRAM Advantages / Disadvantages)

* 장점:

  * 빠른 속도
  * 온칩 구현 가능
* 단점:

  * 낮은 밀도
  * 큰 면적
  * DRAM 대비 높은 전력


## DRAM (동적 랜덤 접근 메모리)

### 1T1C 셀 구조

(1T1C Cell Structure)

* 트랜지스터 1개 + 커패시터 1개
* 커패시터 전하로 데이터 표현


### 동적 특성

(Why “Dynamic”)

* 누설로 인해 전하 감소
* 주기적 리프레시 필요


### 읽기 / 쓰기 / 리프레시

(Read / Write / Refresh)

* 읽기 시 전압 변화 감지 후 복원
* 리프레시는 읽고 즉시 다시 쓰는 과정


## 전압 전달과 센스 앰프

(Voltage Transfer and Sense Amplifier)

* 패스 트랜지스터로 인한 VTH 손실 발생
* 센스 앰프가 이를 보상하여 완전한 논리 레벨 복원


## Verilog/HDL에서의 메모리 구현

(Memory Implementation in Verilog/HDL)

* 레지스터 파일:

  * reg 타입 사용
  * 표준 셀 합성 가능
* SRAM:

  * 파운드리 매크로 사용
  * Verilog로 동작 모델링만 가능


## 메모리 접근 타이밍

(Memory Access Timing)

* 레지스터 파일:

  * 읽기 0 사이클
  * 쓰기 1 사이클
* SRAM:

  * 읽기 1 사이클 지연
* DRAM:

  * 80~250ns 지연
  * 리프레시 영향


## 메모리 디코더와 주소 매핑

(Memory Array Decoders & Addressing)

* 디코더:

  * 이진 주소 -> 단일 활성 라인
* 주소 폴딩:

  * 1×1024 -> 32×32 배열
* 메모리 맵:

  * 상위 주소: 메모리 블록 선택
  * 하위 주소: 블록 내부 주소