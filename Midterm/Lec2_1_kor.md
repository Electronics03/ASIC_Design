# ASIC 설계의 이해 1

## ASIC 설계 개요

이번 강의는 ASIC(Application-Specific Integrated Circuit, 응용 특화 집적회로) 설계의 개요에 관한 내용이다.
이 강의에서는 반도체 또는 칩 설계를 어떻게 시작하는지, 즉 ASIC 설계의 전반적인 절차를 단계별로 소개하고자 한다.
또한 실제 칩 설계에 사용되는 아날로그 및 디지털 회로 설계 기법, 관련 설계 도구, 그리고 설계에 필요한 주요 기술들에 대해서도 함께 다룰 예정이다.

먼저, 우리는 이미 ASIC의 정의에 대해 간단히 살펴본 바 있다.
ASIC은 특정한 목적이나 응용 분야에 맞춰 설계된 집적회로(IC)를 의미한다.

이전에 예로 들었던 범용 반도체(general-purpose semiconductor)에는 CPU(중앙처리장치)와 GPU(그래픽처리장치)가 있다.
CPU는 주로 데스크톱이나 노트북에서 사용되고, GPU는 그래픽 연산 가속에 특화되어 데스크톱이나 클라우드 서버 등에서도 널리 활용된다.

하지만 이러한 범용 프로세서(general-purpose processor)와 달리, ASIC은 모든 연산을 수행할 수 있도록 설계되지 않는다.
ASIC은 특정한 기능과 응용만을 수행하도록 최적화된 회로다.

예를 들어, 스마트 카메라(smart camera)나 AI 연산 가속기(AI accelerator)와 같은 시스템이 그 대표적인 사례다.
이러한 칩들은 특정 응용 목적을 위해 맞춤형으로 설계되며, 제한된 연산을 고효율로 처리하도록 구성된다.

따라서 CPU나 GPU와 달리, ASIC은 플랫폼과 응용 환경에 따라 구조가 달라지는 반도체이다.
즉, 사용하는 플랫폼이 바뀌거나 응용 목적이 달라지면, 그에 맞춰 ASIC의 아키텍처(architecture)나 회로(circuit) 역시 함께 변경된다.
이는 ASIC이 항상 특정 작업에 최적화되어야(optimized for specific tasks) 하기 때문이다.

| 구분    | CPU (Central Processing Unit) | GPU (Graphics Processing Unit) | ASIC (Application-Specific IC) |
| ----- | ----------------------------- | ------------------------------ | ------------------------------ |
| 설계 목적 | 범용 연산 처리                      | 그래픽 및 병렬 연산 가속                 | 특정 기능 수행                       |
| 활용 분야 | 데스크톱, 노트북                     | 데스크톱, 클라우드 서버                  | 스마트 카메라, AI 가속기 등              |
| 유연성   | 높음                            | 중간                             | 낮음 (특정 응용에 최적화)                |
| 설계 특징 | 다양한 명령어와 연산 지원                | 병렬 연산 구조 최적화                   | 제한된 기능에 고효율 설계                 |

## ASIC 설계 과정 개요

### System Specification

그렇다면 ASIC 설계 과정은 어떻게 진행될까?
앞서 말했듯이, ASIC을 설계하려면 먼저 목표 응용(target application)과 명세(specification)를 명확히 해야 한다.

예를 들어 스마트 카메라나 AI 가속기를 설계한다고 하면,
그 응용에 필요한 연산의 종류를 구체적으로 정의해야 한다.
예를 들어, 행렬 곱셈(matrix multiplication), 지수 함수(exponential function), 제곱근(square root) 등의 기능이 필요할 수 있다.

이러한 명세가 정해져야만, 실제 회로 설계 단계로 넘어갈 수 있다.
명세는 ASIC 설계 전 과정을 통제하는 기준이 된다.
또한 설계 명세에는 소비 전력(power consumption), 칩 면적(area) 같은 요소가 포함된다.

마지막으로 중요한 명세는 속도(speed)다.
예를 들어 카메라 한 프레임을 처리할 때, 한 프레임을 처리하기까지 허용되는 시간 제한(time limit)이 얼마인지가 중요하다.
이러한 요구사항들이 모두 정해져야, 비로소 실제 칩 설계의 다음 단계로 진행할 수 있다.

### Architecture Design

회로 설계 단계로 들어가기 전에, 먼저 전체 아키텍처(architecture)를 정의해야 한다.
즉, 어떤 IP 블록(IP block)들을 사용할지 결정해야 한다는 뜻이다.

예를 들어 스마트 카메라(smart camera)를 설계한다고 하자.
이 경우 카메라 센서(camera sensor)가 필요하며, 이 센서는 반드시 메인보드나 컴퓨터(PC)와 통신할 수 있어야 한다.
이를 위해 MIPI 같은 특정 통신 인터페이스가 필요하고,
이 인터페이스를 지원하기 위한 관련 IP 블록을 포함시켜야 한다.

#### IP block?
> IP 블록(Integrated Intellectual Property Block)은 지적 재산(IP, Intellectual Property)이라는 이름 그대로, 특정 기능을 수행하도록 이미 설계되어 있는 하드웨어 모듈을 말한다.
즉, ASIC이나 SoC(System on Chip) 설계 시
매번 회로를 새로 설계하지 않고 검증된 설계 자원을 재사용하기 위해 사용하는 모듈 단위의 설계 자산이다.

또한, 보드(board) 설계 시 USB와 같은 다른 통신 프로토콜이나,
AI 가속기(accelerator) 같은 연산 블록을 추가로 포함할 수도 있다.
예를 들어 스마트 카메라의 영상 처리를 가속하기 위해 AI 가속기를 탑재한다면,
그에 해당하는 AI accelerator IP가 아키텍처에 통합되어야 한다.

이처럼 아키텍처 설계 단계에서는 필요한 모든 IP 블록과 그들의 구성(specification)을 정의해야 한다.
그리고 단일 IP 블록이라 하더라도 여러 가지 설계 옵션(design option)이 존재한다.
예를 들어 AI 가속기의 경우,

* 사용할 연산 정밀도(precision),
* 사용할 행렬 연산 크기(array size),
* 사용할 온칩 메모리(on-chip memory)의 크기 등을 설계자가 직접 결정해야 한다.

### Front-End Circuit Design (Analog & Digital)

이러한 아키텍처 정의 단계를 마친 후에는 실제 칩 설계(actual chip design) 단계로 들어간다.
이 설계는 아날로그 회로 설계(analog circuit design)와 디지털 회로 설계(digital circuit design)로 나뉜다.

두 분야 모두 설계 과정은 기본적으로 동일하게 전단(front-end)과 후단(back-end)으로 구분된다.
즉, 회로 설계 전체를 하나의 "라인(line)"으로 본다면,
Front-End of Line (전단 설계)은 회로의 논리적 정의와 동작 설계를 의미하고,
Back-End of Line (후단 설계)은 실제 물리적 구현(physical realization)을 담당한다.

그렇다면 이 두 과정의 차이는 무엇일까?
Front-End는 회로의 기능적 정의(functional definition)에 집중한다.
즉, 금속 배선(metal routing)이나 트랜지스터의 물리적 형태 같은 구체적인 물리 구조를 고려하지 않고,
회로의 동작을 Verilog 코드나 회로도(schematic)로 표현하는 단계다.

반면 Back-End는 실제 물리적 구현을 다루는 단계다.
즉, 회로도의 논리 소자들을 MOSFET 단위로 매핑(mapping)하고,
각 소자들을 실제 배선(wire)으로 연결하는 과정을 포함한다.
따라서 Back-End of Line은 회로의 물리적 구현(physical implementation)을 담당하는 과정이라고 할 수 있다.

일반적으로 디지털 회로 설계자(digital circuit designer)는
모듈(module)을 정의하기 위해 Verilog 프로그램을 작성한다.
이렇게 작성된 Verilog 모듈이 바로 Front-End of Line (전단 설계)의 최종 결과물이 된다.

반면, 아날로그 회로 설계자(analog circuit designer)는
MOSFET(MOS Field Effect Transistor)의 종류(NMOS, PMOS)에 따른 배선(wire)과 연결 관계(connection)를 회로도(schematic) 형태로 설계한다.
따라서 아날로그 설계에서의 전단 결과물은 Verilog 코드가 아니라 회로도 형태의 설계도다.

이러한 Front-End 단계를 마친 후에는 Back-End (후단 설계) 단계로 넘어가게 되며,
여기서 Verilog 모듈이나 회로도가 물리적으로 구현(physical implementation)된다.

### Back-End Circuit Design (Analog & Digital)

그런데 이러한 물리적 구현을 진행하려면, 단순히 우리가 작성한 설계 파일(예: Verilog, schematic)만으로는 부족하다.
추가로 파운드리(Foundry)로부터 제공받는 기술 파일(technology file)이 필요하다.
파운드리(Foundry)와 Back-End 설계자가 소통하기 위한 기술 명세서이다.
Back-End 설계자는 이 technology file을 바탕으로 회로 설계를 진행한다.

이 파일에는 다음과 같은 공정 관련 정보(process parameters)가 포함되어 있다:

* 금속 배선 간 최소 간격(minimum metal spacing)
* 트랜지스터의 최소 폭(minimum width)
* 단일 소자의 실제 형태(actual device shape)
* 금속층의 개수(available metal layers)
* 각 층의 최대 크기 및 제약 조건(maximum size constraints)

즉, 이 technology file은 실제 반도체 공정에서 가능한 물리적 제약 조건과 설계 규칙(design rules)을 정의한 문서다.

이렇게 기술 파일(technology file)을 받으면, 우리는 그것을 통해
회로를 실제 물리적 영역(실리콘 상)에서 어떻게 배치하고(locating, placing) 배선해야 하는지를 결정할 수 있게 된다.
즉, 회로의 실제 배치 정보는 반드시 이 기술 파일을 바탕으로 정의된다.

이 Back-End 설계(후단 설계)의 대부분은 EDA(Electronic Design Automation)라고 불리는 소프트웨어 도구에 크게 의존한다.

* 아날로그 설계자(analog engineer)는 보통 레이아웃(layout)을 직접 수작업으로 그린다.
* 하지만 디지털 설계자(digital engineer)는 큰 블록(large-size macro)을 직접 배치한 뒤, 나머지 작은 회로들(standard cell이나 small circuit)은 자동 배치 및 배선(auto placement and routing) 기능을 이용해 EDA 툴이 자동으로 처리한다.

이 과정을 마치면 최종적으로 GDS(Graphic Data Stream) 파일(GDSII format)이 생성된다.
이 파일은 칩의 실제 레이아웃 정보를 담고 있으며,
파운드리에서 칩 제조(Fabrication)에 사용된다.
이 파일이 바로 Back-End 설계의 최종 산출물이다.

이 GDS 파일은 파운드리(Foundry)로 전달되어 실제 칩 제조에 사용된다.
파운드리는 이 레이아웃 데이터를 기반으로 웨이퍼 상에서 칩을 제작(fabrication)한 뒤,
완성된 다이를 패키징(package)하여 완성품 형태로 전달한다.

물론, 패키징은 다른 전문 회사에 맡길 수도 있다.
최종 칩을 받은 후에는 기능 검증(functional verification)을 진행하여
모든 기능이 제대로 작동하는지를 확인한다.
문제가 없으면 이 칩은 양산(production) 단계로 넘어가게 된다.

## System Specification

이제 각 단계에 대해 구체적으로 살펴보겠다.
앞서 언급했듯이, 첫 번째 단계는 시스템 명세(System Specification) 단계다.

이 단계에서 가장 중요한 것은

* 목표 성능(performance)이 어느 정도인지,
* 칩 다이(die)의 크기를 얼마나 크게 설계할 수 있는지 를 결정하는 것이다.

칩의 다이 크기가 커질수록 제조 단가는 급격히 증가한다.
따라서 예산(budget)이나 공정상의 제약(process limitation)을 고려하여
칩의 최대 크기를 제한해야 한다.
즉, 다이 크기(die size)는 매우 중요한 설계 요소다.

또한, 어떤 통신 프로토콜(communication protocol)을 사용할지도 명확히 해야 한다.
예를 들어 I²C, Wi-Fi, PCIe, I²S, USB 등의 인터페이스는
칩이 다른 모듈, 패키지, 혹은 PC와 데이터를 교환하는 방식을 결정한다.
따라서 사용할 인터페이스의 종류가 시스템 전체 구조에 큰 영향을 미친다.

## Architecture Design

시스템 명세(specification)를 정의한 뒤에는,
해당 응용(application)에 가장 적합한 아키텍처(architecture)를 설계해야 한다.

이 단계에서 해야 할 주요 작업은 다음과 같다:

* 어떤 IP 블록을 사용할지 결정하고,
* 각각의 IP 블록을 어디에 배치할지(placement)를 정하며,
* 병렬 처리를 지원한다면, 몇 개의 연산 유닛(processing element)이나 계산기(calculator)를 칩에 포함시킬지를 정하는 것이다.

일반적으로 아키텍처 설계자는 블록 다이어그램(block diagram)을 작성한다.
이 도식에는 각 IP 간의 연결 관계(connection)와 데이터 흐름(data flow)이 표현된다.
이를 통해 전체 시스템의 구조를 시각적으로 정의하고,
설계한 아키텍처의 예상 성능(performance estimation)을 평가할 수 있다.

아키텍처 설계의 목표는 주로 계산량(computation amount)과 메모리 접근 횟수(memory access amount)를 최소화하는 것이다.
아키텍처 수준의 시뮬레이터(architecture simulator)를 통해
이러한 계산 횟수나 메모리 접근량은 추정할 수 있지만,
실제 전력 소모(power consumption)나 지연(latency),
전달 응답(transient response) 같은 세부적인 특성은
이 단계에서는 정확히 측정하기 어렵다.

따라서 이 단계에서는 대략적으로 다음과 같은 것을 계산한다:

* 특정 연산에 필요한 계산 횟수
* 수행에 필요한 사이클 수
* 접근해야 하는 메모리의 양

이러한 시뮬레이션은 고급 언어(high-level language)를 이용해 수행할 수 있다.
예를 들어 C 언어, Python, SystemC 등을 이용해
아키텍처의 연산 구조를 모의(simulation)할 수 있다.

## Front-End Design (Digital Circuit)

아키텍처 설계가 완료되면, 여러 디지털 회로 설계팀(digital circuit teams)이
각각의 IP 블록 설계 항목(specific item)을 담당하게 된다.

각 팀은 담당한 IP를 회로도(schematic) 또는 Verilog 프로그래밍을 통해 설계한다.
특히 디지털 설계자(digital designer)들은 Verilog를 이용해 하드웨어를 기술하는데,
이를 RTL(Register Transfer Level) 설계라고 부른다.
(이 RTL의 개념은 뒤에서 자세히 설명할 예정이다.)

이렇게 작성된 RTL 코드는 Verilog 시뮬레이션을 통해 기능을 검증한다.

Front-End 설계 단계에서 설계자들이 주로 수행하는 일은

* 어떤 표준 셀(standard cell)을 사용할지,
* 몇 개의 표준 셀이 필요한지, 즉 회로 기능 구현을 위한 논리 구성 결정(logical implementation)이다.

따라서 이 단계에는 단순히 RTL 코드를 작성하는 것뿐만 아니라,
합성(synthesis)과 게이트 수준 검증(gate-level verification) 과정도 포함된다.
이 두 과정의 구체적인 내용은 뒤에서 설명할 것이다.

### RTL Design

Verilog 프로그램을 작성하는 과정은 곧 RTL(Register Transfer Level) 설계 단계에 해당한다.
이 RTL 코드의 기능은 Verilog 시뮬레이션(simulation) 또는 Verilog 검증(verification)을 통해 확인할 수 있다.

하지만 RTL 코드는 논리 게이트(logic gate) 수준의 정보를 직접 기술하지 않는다.
즉, 예를 들어 가산기(adder)를 설계한다고 하자.
가산기는 기본적으로 조합 논리 회로(combinational logic circuit)들의 조합으로 구현될 수 있다.
따라서 Verilog로 기술된 동작 수준의 코드를 기본 논리 게이트(AND, OR, NOT 등)의 조합으로 변환해야 한다.

### Synthesis

이러한 변환 과정을 바로 합성(synthesis)이라고 한다.
즉, 합성 과정이란 RTL 수준의 Verilog 코드를 논리 게이트 수준의 회로로 변환하는 과정이다.

합성이 끝난 뒤에는 변환이 올바르게 이루어졌는지를 확인해야 한다.
이 과정을 게이트 수준 검증(gate-level verification)이라고 한다.

즉, Verilog 코드가 논리 게이트 수준으로 변환된 후,
그 변환된 회로(게이트 간 연결 구조)가 원래의 동작을 제대로 구현하는지 검증하는 단계다.
이 검증은 더 이상 Verilog 코드 단위가 아니라, 게이트 간 연결 구조(gate-level netlist)를 기반으로 수행된다.

#### Synthesis with VerilogHDL

```sv
module PC(PC_out, PC_in, reset, clk);
    output reg [31:0] PC_out;
    input  [31:0] PC_in = 0;
    input  reset, clk;

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            PC_out <= 0;
        else
            PC_out <= PC_in;
    end
endmodule
```

이것이 전형적인 Verilog 프로그램의 예시이다.
이 코드를 합성(synthesis)하면,
해당 코드가 표준 셀(standard cell)들의 조합으로 변환되는 것을 볼 수 있다.

```
//==============================================
// Example of Gate-Level Netlist Fragment
//==============================================

AOI22D0BWPT73DP14H0WT engine_enc_unit_g403263 (
    .A1 (#engine_enc_unit_ltth_reg[30][2]),
    .A2 (engine_enc_unit_n_692941),
    .B1 (engine_enc_unit_n_521351),
    .B2 (#engine_enc_unit_reg[26][2]),
    .C  (engine_enc_unit_n_598024)
);

//----------------------------------------------
// D Flip-Flop for ltth_reg[30][2]
//----------------------------------------------
DFSDN1BWPT73DP14H0WT #engine_enc_unit_ltth_reg_reg[30][2] (
    .SDN (engine_enc_unit_n_545360),
    .CP  (engine_enc_unit_n_598024),
    .D   (engine_enc_unit_n_598025),
    .Q   (#engine_enc_unit_ltth_reg[30][2]),
    .QN  (UNCONNECTED288037)
);

//----------------------------------------------
// Additional AOI and NAND logic examples
//----------------------------------------------
OAI21D0BWPT73DP14H0WT engine_enc_unit_g103388 (
    .A1 (engine_enc_unit_n_547393),
    .A2 (engine_enc_unit_n_545781),
    .B  (engine_enc_unit_n_598023),
    .ZN (engine_enc_unit_n_598025)
);

ND2D0BWPT73DP14H0WT engine_enc_unit_g136088 (
    .A1 (engine_enc_unit_n_598023),
    .A2 (engine_enc_unit_n_545445),
    .ZN (engine_enc_unit_n_598024)
);

//----------------------------------------------
// Another Flip-Flop for ltth_reg[26][2]
//----------------------------------------------
DFSDN1BWPT73DP14H0WT #engine_enc_unit_ltth_reg_reg[26][2] (
    .SDN (engine_n_936),
    .CP  (engine_enc_unit_n_598027),
    .D   (engine_enc_unit_n_594904),
    .Q   (#engine_enc_unit_ltth_reg[26][2]),
    .QN  (UNCONNECTED288037)
);
```
여기 보이는 것이 바로 합성(synthesis)의 결과이다.
앞서 말했듯이, 각 모듈 인스턴스(module instantiation)는
하나의 표준 셀(standard cell)로 치환되어 있다.

예를 들어, "AOI"는 AND-OR-Inverter 게이트를 의미하고,
"DFF"는 D-플립플롭(D Flip-Flop),
"NAND"는 NAND 게이트를 뜻한다.
이러한 논리 소자들의 정의는 이미 표준 셀 라이브러리(standard cell library) 내부에 포함되어 있다.

즉, Verilog 코드 내의 각 모듈 정의(module definition)는
결국 CMOS 논리 회로(CMOS logic circuit)의 조합으로 이루어진
표준 셀(standard cell) 단위의 블록으로 변환된다.

(표준 셀의 세부 내용은 이후에 더 자세히 다룰 것이다.)

합성 과정을 마치면, 다음 단계는 Back-End of Line (후단 설계)이다.
앞서 말했듯이, 후단 설계의 역할은 회로의 물리적 구현(physical implementation)이다.

즉, 합성이 완료된 시점에는 다음과 같은 정보가 이미 결정되어 있다:

* 어떤 포트(port)가 어떤 신호선(wire)에 연결되는지
* 각 기능을 구현하기 위해 어떤 표준 셀(CMOS 회로)이 사용될지

이 정보를 기반으로 실제 배치와 배선을 수행하는 것이 바로 Back-End 단계다.

## Back-End Design (Digital Circuit)

이제 이러한 정보(표준 셀 구성과 포트 연결)가 정해지면,
다음 단계는 표준 셀(standard cell) 혹은 CMOS 논리 회로(CMOS logic circuit)를 실제로 배치하는 것이다.

즉, 설계자가 해야 할 일은
1. 각 표준 셀을 적절한 위치에 배치(placement)하고,
2. 포트 간의 연결 정보를 기반으로
   구리(Cu)나 알루미늄(Al) 금속 배선을 이용해 포트 간 연결(routing)을 완성하는 것이다.

이것이 바로 Back-End of Line 과정의 핵심이다.

요약하면, 이 단계는 다음 두 가지 작업을 포함한다:
* 표준 셀의 배치(placement of standard cells)
* 신호 배선(signal routing)

따라서 이 과정을 통틀어 "배치 및 배선(Place and Route, P&R)" 과정이라고 부른다.
즉, 표준 셀을 배치한 뒤, 금속 배선층을 통해 각 셀을 연결하는 것이
Back-End의 핵심 절차다.

배치(placement)를 수행하면, 표준 셀들이
칩 내의 특정 영역(certain area)에 위치하게 된다.

이후 배선(routing)을 수행하면,
각 포트 간의 연결이 실제 금속선으로 이어진다.
이때 회로도나 레이아웃 상에서 보이는 하얀색 혹은 노란색 선들이
바로 이 배선 결과를 나타낸 것이다.

즉, 배선을 완료한 뒤에는
각 포트(port)와 모듈(module) 사이의 연결 관계가
물리적으로 완성된다.

또한 실제 칩 레이아웃(chip layout)을 보면,
일정한 구역(partition)마다
수많은 논리 회로(logic circuit)와 표준 셀(standard cell)이
집적되어 있는 모습을 확인할 수 있다.

## ASIC 설계 과정 요약

요약하자면, ASIC 설계 과정은 크게 세 부분으로 나눌 수 있다:

1. 검증(Verification)
2. 패키징(Packaging)
3. 테스트(Testing)

하지만 우리가 집중해야 할 핵심 단계는 그 중간에 위치한 설계(Design) 부분이다.

디지털 회로 설계자의 주요 업무는
먼저 아키텍처(Architecture)를 정의하고,
그 다음 합성(Synthesis)을 수행하는 것이다.

이 합성 과정은 EDA(Electronic Design Automation) 도구를 이용해 수행된다.
주요 합성 도구로는 다음과 같은 것들이 있다:

* Synopsys Design Compiler
* Cadence Genus

이러한 툴들은 RTL(Register Transfer Level) 코드, 즉 Verilog로 작성된 설계 코드를 입력받아
이를 게이트 수준 넷리스트(gate-level netlist)로 변환한다.
이 넷리스트에는 다음 정보가 포함된다:

* 사용된 논리 게이트(logic gate) 또는 표준 셀(standard cell)의 정의
* 각 셀 간의 연결 관계(connection or net definition)

이 전체 과정을 Front-End of Line (전단 설계) 또는 간단히 Front-End라 부른다.

그 다음 단계가 Back-End of Line (후단 설계)이다.
이 단계에서는 합성된 표준 셀들을
실제 물리적 위치에 배치(placement)하고,
금속 배선을 통해 각 셀을 연결(routing)한다.
이 과정을 Place & Route (P&R)라고 부른다.

이후 모든 배치 및 배선이 완료되면,
최종적으로 레이아웃 파일(layout file)이 생성된다.
이 파일에는 표준 셀의 위치 정보와 배선 정보가 모두 포함되어 있으며,
이것이 칩 제조를 위한 최종 설계 산출물(final layout file)이다.

### ASIC design flow

ASIC 설계 흐름(ASIC design flow)을 도식적으로 나타내면 다음과 같다.
설계의 흐름은 다음과 같이 진행된다:

1. 먼저 Verilog 프로그램(Verilog Program)을 작성한다.
2. 그다음 합성(Synthesis)을 수행하여,
게이트 수준 넷리스트(Gate-Level Netlist)를 얻는다.
3. 이후 이 넷리스트를 기반으로 기능 검증(functional verification)을 수행하고,
필요 시 디버깅(debugging)을 진행한다.
4. Front-End 단계를 마치면, 이 게이트 수준 넷리스트가
플로어플랜(Floorplan) 단계로 전달된다.
이 단계에서는 각 IP 블록이나 표준 셀(standard cell)의 배치 위치를 정의한다.
5. 그다음 수행되는 것이 배선(Routing) 단계다.
이 단계에서는 금속 배선층을 이용해 포트 간의 연결 관계를 실제로 정의한다.
6. 배선이 끝난 후에는, 최종 레이아웃 파일(final layout file)을 기반으로
다시 한 번 기능 검증(Verification)을 수행한다.
7. 만약 오류가 발생한다면,
이 과정을 반복하여 수정한다.

이후의 모든 단계, 즉 배치(Placement)와 배선(Routing)을 포함한
물리적 구현 과정 전체를 물리 설계(Physical Design) 또는 Back-End of Line이라 부른다.

### 요약

좋다. 이제 우리는 전체적인 ASIC 설계 흐름의 형식을 이미 살펴보았다.

앞서 말했듯이, 논리 게이트(logic gate)가 한 번 정의되면,
그 게이트는 손쉽게 CMOS 논리 회로(CMOS logic circuit) 형태로 변환될 수 있다.
그리고 이러한 CMOS 회로는 표준 셀(standard cell)로 구성되며,
결국 배치 및 배선(place and route) 과정을 통해
실제 웨이퍼 상의 물리적 구조(wafer-scale implementation)로 구현된다.

즉, 디지털 회로 설계에서 특히 Front-End 단계에서 해야 할 핵심은 다음과 같다:

* Verilog 모듈(Verilog module)을 정의하고,
* 각 모듈 간의 연결 관계(connection)를 설계하여,
* 최종적으로 시스템 수준의 동작(system-level functionality)을 실현하는 것이다.

다시 말해, Front-End 설계자는 시스템의 기능을 논리적으로 기술하고,
이를 표준 셀과 연결 구조로 표현함으로써
하드웨어의 동작을 구현하는 역할을 맡는다.

## Foundry (Fabrication)

이번에는 칩 설계가 완료된 후,
실제 칩이 어떤 형태로 구현되는지를 살펴보겠다.

칩은 기본적으로 다이(Die)와 웨이퍼(Wafer) 위에서 제작된다.

앞서 설명했듯이, 설계가 끝난 칩은
웨이퍼 표면 위에 반복적인 패턴(repeated square pattern) 형태로 인쇄된다.
즉, 하나의 웨이퍼에는 동일한 칩이 여러 개 격자 형태로 새겨져 있다.

이후 이 웨이퍼로부터 개별 칩을 절단(detach or dice) 하면,
각각의 칩은 동일한 정사각형 형태를 가지게 된다.
즉, 우리가 보는 하나의 칩(die)은
웨이퍼 상의 동일 패턴 중 하나를 잘라낸 결과물이다.

### yield

칩 설계는 비용(cost)과 매우 밀접한 관계가 있다.

예를 들어, 28nm 공정(28-nanometer process)에서 칩을 설계할 경우,
제조 비용은 1mm²당 약 10,600달러(USD) 정도가 든다.
즉, 4mm × 4mm 크기의 칩 하나를 설계하려면
약 $160,000(약 2억 원 이상)의 비용이 소요된다.
따라서 단 하나의 칩을 설계하는 것만으로도 매우 높은 비용이 필요하다.

하지만 칩의 전체 비용을 결정하는 또 다른 중요한 요소가 있다.
바로 수율(yield)이다.

수율(yield)이란,
웨이퍼에서 제조된 칩들 중 정상적으로 동작하는 비율,
즉 불량이 없는 제품(non-defective product)의 비율을 의미한다.

웨이퍼 상에 존재하는 검은 점(black spot)은
먼지(dust)나 오염물질(pollution) 등으로 인해 발생한 결함(defect)을 의미한다.
이러한 결함은 여러 가지 원인으로 생길 수 있다.

이 경우, 오염된 부분이 포함된 칩은 정상 동작을 보장할 수 없다.
따라서 웨이퍼 전체에서 실제로 정상적으로 작동하는 영역(clean area)만이
유효한 칩(die)으로 간주된다.

즉, 웨이퍼에 여러 개의 칩이 인쇄되어 있어도
그중 일부는 오염(defect)으로 인해 동작하지 못한다.
결국 깨끗한(clean) 영역에 위치한 칩들만이 정상적으로 작동할 수 있으며,
이들만이 최종적으로 양산(production) 단계로 넘어갈 수 있다.

### yield 계산식

수율(yield)은 다음과 같은 비율로 정의된다.
$$
\mathrm{yield} = \frac{\mathrm{정상적으로\ 동작하는\ 칩의\ 수}}{\mathrm{웨이퍼에서\ 얻을\ 수\ 있는\ 전체\ 칩\ 수}}\times 100
$$

즉, 하나의 웨이퍼에서 만들어진 칩 중 정상적으로 동작하는 칩의 비율이 수율이다.
* 수율이 높다(high yield)는 뜻은 한 장의 웨이퍼에서 생산 가능한 정상 칩의 수가 많다는 의미다.
* 수율이 낮다(low yield)는 뜻은 웨이퍼에 많은 칩을 인쇄했더라도, 정상적으로 작동하는 칩이 소수에 불과하다는 뜻이다.

이 수율 문제(yield problem)는 다이 크기(die area)와 밀접한 관련이 있다.

예를 들어, 웨이퍼 상에 결함이 생긴 특정 지점이 있다고 하자.
* 만약 칩 크기가 작다면, 그 결함이 일부 칩만 영향을 주므로 대부분의 칩은 정상이다.
* 하지만 칩 크기가 크다면, 같은 결함 한 지점이 더 큰 면적을 차지하게 되어
  불량 칩이 더 많이 발생할 수 있다.

따라서 칩 크기가 커질수록 수율은 급격히 감소한다.
결국, 너무 큰 다이를 설계하는 것은 제조 수율 측면에서 불리하다.
수율(yield) 문제를 고려할 때,
가능한 한 칩 크기(die size)를 크게 설계하는 것은 바람직하지 않다.

대형 칩 하나를 설계하기보다는,
여러 개의 소형 칩(small chip)을 나누어 설계하고
이들을 실제 시스템에서 병렬로 사용하는 것이 더 효율적이다.
이 접근 방식이 비용(cost)과 수율(yield) 모두에서 유리하다.

또한 파운드리(foundry)는 칩 크기가 커질수록 더 높은 제작비를 요구한다.
즉, 큰 다이를 설계하면 단가가 급격히 상승하게 된다.
결국, 큰 칩을 설계할수록 비용(cost)은 단순히 비례적으로 증가하게 된다.

## PAD

어쨌든 칩이 설계되고 제작되면,
다음과 같은 형태의 칩 사진(chip photograph)을 볼 수 있다.

겉보기에는 대부분 갈색(bronze-brown)을 띠는 일반적인 형태지만,
칩 가장자리 주변에는 작은 네모 모양의 영역(square shape)이 여러 개 배열되어 있다.

이 영역을 패드(pad)라고 부른다.

그렇다면 패드(pad)는 무엇일까?
패드는 외부 칩(external chip)과 신호를 주고받기 위한 접점(interfacing gate)이다.

칩 표면의 대부분 영역은 절연 재료(material)로 덮여 있어서
아날로그 신호나 디지털 신호가 통과할 수 없다.
하지만 이 패드 영역(pad area)만은 예외로,
외부 회로나 다른 칩과의 통신(communication)을 위한 통로 역할을 한다.

따라서 칩이 외부 장치와 통신하려면,
칩 내부의 디지털 신호가 반드시 패드 영역을 통해 전달(propagate)되어야 하며,
이 신호는 이후 금속 배선(wire)을 통해 외부로 연결된다.

정리하자면, 패드(pad)는
외부 칩이나 다른 신호 소스(external sources)와 통신하기 위한 입출력 게이트(gate)이다.
즉, 칩 내부의 신호를 외부로 전달하거나, 외부의 신호를 내부로 받아들이는 역할을 한다.

패드는 크게 두 가지 종류로 구분된다:

1. 신호 패드(Signal Pad): 내부 회로와 외부 회로 간의 데이터 신호 통신(data communication)을 담당한다.

2. 전원 패드(Power Pad):
칩에 전력(power)을 공급한다.
칩이 동작하려면 반드시 전압(voltage)을 공급받아야 하고,
그 전류(current)가 흐를 수 있는 경로가 필요하다.
따라서 전원 패드는 칩 내부 회로로 전압과 전류를 전달하는 역할을 수행한다.

### Signal PAD

이제 실제 칩의 구조를 살펴보면, 내부에는 여러 개의 IP 블록(IP blocks)이 배치되어 있고,
그 외곽에는 앞서 언급한 패드(pad)들이 네모 형태로 둘러싸여 있다.

이 패드는 기능에 따라 신호 패드(Signal Pad)와 전원 패드(Power Pad)로 구분된다.

이제 그중 하나인 신호 패드(signal pad), 또는 입출력 패드(IO pad)를 살펴보자.

앞서 말했듯이, 신호 패드의 역할은
외부 회로와 신호(signal)를 주고받는 것이다.
즉, 통신(communication)을 위한 신호를 송신하거나 수신하는 역할을 한다.

특히 디지털 회로(digital circuit)의 경우,
신호 데이터(data signal)는 전압(voltage)이나 클럭(clock) 형태로 전달된다.
따라서 IO 패드(IO Pad)는 이러한 디지털 신호를 전압의 형태로 송수신하도록 설계되어 있다.

#### Voltage Level Transter

디지털 회로에서는 전압 수준(voltage level)에 따라 신호가 구분된다.

* 전압이 낮을 때(low voltage)는 일반적으로 논리 0(logic 0)을 의미하며, 이를 데이터 ‘0’이라 부른다.
* 전압이 높을 때(high voltage)는 보통 1.2V 정도이며, 이는 논리 1(logic 1), 즉 데이터 ‘1’을 의미한다.

하지만 신호 패드(signal pad) 안에는 단순히 전압만 구분하는 회로가 아니라,
두 가지 다른 회로(two types of circuit)가 함께 포함되어야 한다.
그 이유는 입력 신호를 받을 때(receiving)와 출력 신호를 보낼 때(sending)
필요한 회로 구조가 서로 다르기 때문이다.

예를 들어, 외부에서 들어오는 신호를 받는 경우를 생각해보자.
이때 칩은 외부 입력 전압(external voltage)을 받아들인 후,
이를 칩 내부에서 사용하는 전압 레벨(supply voltage level)로 변환해야 한다.

일반적으로 낮은 전압(low voltage)을 사용하는 데이터는 노이즈(noise)에 매우 취약하다.
즉, 외부 신호에 노이즈가 섞이면 낮은 전압 신호가 잘못 인식되어 ‘0’으로 잘려(truncated) 버릴 수 있다.

이러한 문제를 방지하기 위해,
외부로 데이터를 전송할 때는 전압 레벨을 높인다(pump up the voltage).
즉, 내부 회로의 동작 전압이 약 1.2V라면,
외부 통신에는 더 높은 전압인 1.8V 또는 3.3V를 사용한다.

이처럼 외부 디지털 신호 전송용 통신 회로(external I/O communication)에서는
더 높은 전압 영역(high-voltage region)이 사용된다.

따라서 칩이 외부에서 신호를 받을 때는,
입력 신호의 전압이 칩 내부 전압(on-chip supply voltage)보다 높게 나타난다.
그 이유는 이 신호가 외부 소스(external source)로부터 전달되기 때문이다.

따라서 외부 데이터(external data)는 일반적으로 1.8V 전압 영역에서 동작한다.
그러나 칩 내부의 회로는 보통 1.0V 또는 1.2V 정도의 중간 전압(medium voltage)을 사용한다.
이 전압은 외부 통신 전압보다 낮기 때문에,
전압 변환(voltage conversion) 과정이 반드시 필요하다.

#### Buffer
이 변환 동작을 이해하기 위해 간단한 회로를 생각해보자.

* 외부에서 높은 전압(1.8V)이 입력되면,
  → NMOS는 켜지고(turn on),
  → PMOS는 꺼진다(turn off).
  이때 출력은 그라운드(ground)와 연결되어 낮은 전압(0V)이 된다.

* 반대로 입력 전압이 낮아지면,
  → PMOS가 켜지고,
  → NMOS는 꺼진다.
  이때 회로는 전원 공급선(supply voltage)과 연결되어
  출력이 1.0V 수준의 내부 전압으로 변환된다.

이 회로는 결과적으로 1.8V → 1.0V로 전압을 변환해주는 기능을 수행한다.
구조적으로는 인버터 두 개가 직렬로 연결된 형태이며,
논리적으로는 하나의 버퍼(buffer)처럼 동작한다.

차이점은 각 인버터가 서로 다른 전원 전압(supply voltage)에 연결되어 있다는 점이다.
바로 이 특성 덕분에 전압 변환이 가능하며,
이러한 구조의 회로를 버퍼(buffer)라고 부른다.

따라서 외부에서 들어오는 신호를 칩 내부(inner side)로 전달하려면,
앞서 설명한 것처럼 적절한 회로(proper circuit)가 필요하다.
이러한 회로는 입출력 패드(IO Pad) 내부에 포함되어 있다.
즉, 외부 입력 신호를 내부 전압으로 변환하는 기능을 담당하는 것이다.

#### Level Shifter

하지만 이번에는 반대 상황을 생각해보자.
즉, 칩 내부의 디지털 회로(digital circuit)가 생성한 신호를
외부(external)로 전송하려는 경우다.

이때는 내부 신호가 낮은 전압(low voltage) 상태이므로,
이를 외부 통신에 적합한 높은 전압(high voltage)으로 변환해야 한다.

앞서 말했듯이 칩 내부의 동작 전압은 약 1.0V 수준이지만,
외부 신호 전송에는 1.8V 또는 3.3V와 같은 높은 전압이 사용된다.

따라서 이런 경우에는 레벨 시프터(Level Shifter)라는
특수한 전압 변환 회로가 필요하다.
이제 레벨 시프터(Level Shifter)의 동작 원리를 살펴보자.

1. 입력 전압이 높을 때(high voltage input)
   * 높은 전압이 인가되면(NMOS의 게이트에 전압이 가해지면),
     해당 NMOS 트랜지스터가 켜지고(turn on) 전류가 흐른다.
   * 그러나 회로에는 인버터(inverter)가 존재하므로,
     입력 신호가 높으면 출력은 반대로 낮은 전압(low voltage)이 된다.
   * 이때 특정 NMOS는 꺼지고, 다른 PMOS가 켜지면서
     출력 경로가 끊어져(disconnected) 신호 흐름이 차단된다.

2. M3 NMOS의 역할
   * 이 NMOS가 켜지면(turn on), VSS(그라운드)가 연결된다.
   * 즉, 출력 쪽 회로의 한쪽 노드가 그라운드 전압(0V)으로 고정된다.
   * 이 전압은 대응되는 PMOS(M2)의 게이트에 인가되어
     M2 PMOS를 켜(turn on)준다.

3. M1 NMOS의 역할
   * M1의 게이트에는 높은 전압(high voltage)이 전달된다.
   * 그 결과 M1 NMOS는 꺼지고(turn off),
     출력 노드에는 더 이상 전류가 흐르지 않는다.

이 과정을 거치면,
입력 전압이 1.0V인 경우에도 출력 쪽에서는 1.8V의 높은 전압(high-level voltage)이 만들어진다.
즉, 레벨 시프터는 내부 회로의 저전압 신호(1.0V)를
외부로 출력할 수 있는 고전압 신호(1.8V)로 변환하는 기능을 수행한다.

이번에는 입력 전압이 낮을 때(low or general voltage input), 즉 논리 0(0V 근처)일 때의 경우를 보자.

1. 입력 전압이 낮으면,
   → M3 NMOS는 꺼지고(disconnected),
   → 이로 인해 출력 노드가 높은 전압(high voltage)을 받게 된다.

2. 이 전압은 M4 NMOS의 게이트로 전달되어 M4를 켠다(turn on).
   그 결과, 낮은 전압(0V)은 출력 경로를 따라 전파(propagate)된다.

3. 동시에 M1 NMOS도 켜지고,
   M2 PMOS에는 높은 전압이 걸려 꺼지므로(turn off),
   출력은 그라운드(ground)에 연결되어 낮은 전압을 유지한다.

즉, 입력이 낮을 때 회로의 출력은 정상적으로 0V(low level)이 된다.

정리하자면,
이 회로는 입력이 1.0V일 때 1.8V로,
입력이 0V일 때 0V로 신호를 변환하여,
저전압(1.0V) → 고전압(1.8V) 전송을 안정적으로 수행한다.

따라서 칩 내부 신호를 외부로 송신할 때는
이러한 레벨 시프터(Level Shifter) 회로가 반드시 필요하다.

#### 서로 반대로 사용한다면?

그렇다면 반대의 경우는 어떨까?
즉,

* 레벨 시프터(level shifter)를 이용해 외부 → 내부 신호(external to internal) 전송이 가능한가?
* 또는 버퍼(buffer)를 이용해 내부 → 외부 신호(internal to external) 전송이 가능한가?

정답은 부분적으로만 가능하다(partially true).

먼저,
레벨 시프터를 외부 → 내부 신호 변환에 사용하는 것은 가능하다.
하지만 이 방법은 구조가 복잡하고(transistor structure is complex),
그 결과 신호 전송 지연(latency)이 길어진다는 단점이 있다.

반대로,
버퍼를 내부 → 외부 신호 전송에 사용하는 것은 불가능하다.
그 이유는 다음과 같다.

버퍼는 내부 공급 전압(supply voltage)이 1.0V이고,
외부 통신 전압이 1.8V인 상황에서 올바르게 동작하지 않는다.
이 경우, 트랜지스터의 게이트 전압이 애매한 중간 영역(tri-region)에 놓이게 된다.
즉, PMOS와 NMOS가 모두 부분적으로 켜진 상태(partially on)가 되어,
회로가 메타안정 상태(metastable state)에 빠진다.

#### Metastable state

그렇다면 메타안정 상태(metastable state)란 무엇일까?

메타안정성(metastability)이란,
하나의 노드(node)나 배선(wire)이
전원(VDD)과 그라운드(GND)에 동시에 구동(driven)되어
출력 전압이 명확하게 결정되지 않는 불안정한 상태를 의미한다.

이 경우,

* VDD 쪽 구동 전류의 세기(driving strength)와
* GND 쪽 구동 전류의 세기가 서로 충돌(contact)하게 되어,
  회로는 출력 전압을 정확히 ‘0’ 또는 ‘1’로 결정하지 못한다.

결과적으로 이 노드의 전압은
회로 내부의 미세한 차이뿐 아니라,
온도 변화(thermal energy)나 외부 잡음(noise) 같은
외부 요인에 의해서도 쉽게 영향을 받는다.

따라서 출력값이 예측 불가능하고 불안정하게 흔들리는 상태,
이것이 바로 메타안정 상태다.

이 때문에,
버퍼(buffer)는 내부 → 외부 데이터 전송(1.0V → 1.8V) 용도로 사용할 수 없다.
이런 경우에는 반드시 레벨 시프터(level shifter) 회로를 사용해야 한다.

### Power PAD

이제 전원 패드(power pad)에 대해 살펴보자.

전원 패드는 종류가 다양하지만, 여기서는 대표적인 세 가지 유형(three typical types)만 소개하겠다.

1. VDDIO Pad (입출력 전원 패드)
   → 이 패드는 레벨 시프터(level shifter)에 사용된다.
   앞서 말했듯이, 외부에서 입력되는 데이터는 약 1.0V 영역(domain)으로 변환되어야 한다.
   하지만 이를 위해 칩 내부와 외부의 전압 도메인(voltage domain)이 분리되어야 한다.

   즉, 내부 회로에서 동작하는 인버터(inverter)는 1.0V 수준의 내부 전압 도메인(VDDL domain)에서 작동하지만,
   외부 신호는 1.8V 혹은 그 이상의 IO 전압(VDDH, High Domain)을 사용한다.

   따라서 레벨 시프터(level shifter)가 제대로 동작하기 위해서는
   외부 전압(VDDIO, 1.8V)과 내부 전압(VDDL, 1.0V)을 각각 독립적으로 공급받아야 한다.

2. VDDL Pad (내부 전원 패드)
   → VDDL은 칩 내부 회로(on-chip logic)에 사용되는 저전압 전원이다.
   즉, 내부 로직 회로나 버퍼(buffer), 그리고 일부 레벨 시프터의 저전압 구간에 전원을 공급한다.

   이 전압은 외부 IO 전압(VDDIO)보다 낮으며,
   내부 회로 동작을 위한 기본 전원(low-voltage power) 역할을 한다.

결국 요약하자면,

* VDDIO (또는 VDDH) : 외부 신호 전송용 고전압 (1.8V 등)
* VDDL : 내부 로직용 저전압 (1.0V 등)

이 두 가지 전원은 칩 내에서 별도의 경로로 공급되어야 하며,
특히 레벨 시프터는 두 전압 도메인을 모두 필요로 한다.

신호 패드(signal pad) 내부의 회로 구성을 다시 보면,
레벨 시프터(level shifter)는 두 개의 전압 도메인(power domain)을 모두 사용한다.
즉,

* 고전압 도메인(VDDIO 또는 VDDH) — 외부 신호용
* 저전압 도메인(VDDL) — 내부 로직용
  두 전원이 동시에 필요하다.

반면, 버퍼(buffer)는 오직 저전압 도메인(VDDL)만 사용하여 동작한다.

따라서 하나의 전원 패드(VDD Pad)를 통해 전압을 공급하면,
그 전원은 다음 회로들에 동시에 전달된다:

* 버퍼(buffer)
* 레벨 시프터(level shifter)
* 칩 내부의 CMOS 로직 회로(on-chip CMOS logic circuits)

반면, VDDIO 패드(IO 전원 패드)는
오직 레벨 시프터에만 전압을 공급한다.

### Ground PAD

이제 그라운드 패드(ground pad)를 보자.

그라운드 패드는 칩 전체의 기준 전압(baseline voltage)을 제공한다.
즉,

* 버퍼(buffer)
* 레벨 시프터(level shifter)
* 내부 회로(internal circuits)
  모두 동일한 기준 전압인 GND (0V)에 연결된다.

이 그라운드 패드는 내부 회로 전원 도메인뿐 아니라
외부 IO 전원 도메인에서도 공유(shared)될 수 있다.

마지막으로, 문서에서 언급된 DVSS는
레벨 시프터 전용 그라운드(domain-specific ground)를 의미한다.
즉, DVSS는 레벨 시프터용 내부 접지(ground for level shifter)다.

### Internal Power Ring

그렇다면 질문이 생긴다.
레벨 시프터(level shifter)나 버퍼(buffer)와 같은 회로에
전원(power)을 어떻게 공급해야 할까?
그리고 패드(pad) 내의 전력선(power wire)은 어떤 구조로 되어 있을까?

패드에 전원을 공급하는 방법은 두 가지가 있다.

#### (1) 외부 전원 링(External Power Ring)을 이용하는 방법

이 방식에서는 칩 외곽에 전원 링(power ring)을 만들어
그 링을 통해 패드에 전력을 공급한다.

예를 들어,

* VDD (전원),
* DVDD (레벨 시프터용 전원),
* VSS (그라운드)
  와 같은 전원선들이 칩 외곽의 금속층에 배치된다.

이때 신호 패드(signal pad)는
이 외부 금속층(thick outer metal)으로부터
필요한 전원(DVDD, VDD, VSS)을 추출(extract)하여 공급받는다.

이 방식은 구조적으로 단순하고 직관적이다.
즉, 전원선을 외부에 두고 필요한 곳에서 끌어다 쓰는 형태이다.

하지만 이 방식에는 몇 가지 단점(disadvantages)이 있다.

1. 외부 공간이 많이 필요하다.
   → 외곽에 전원 링을 배치해야 하므로,
   칩의 면적이 증가하고 레이아웃이 복잡해진다.

2. 전압 강하(voltage drop)가 커진다.
   → 전류가 링을 따라 먼 거리를 이동해야 하므로,
   저항성 손실(IR drop)이 발생한다.

3. 전류 공급 속도가 느리다.
   → 전류가 긴 경로를 따라 흐르기 때문에
   순간적인 전류 요구(surge current)에 빠르게 대응하지 못한다.

이러한 이유로, 외부 전원 링 방식은
직관적이긴 하지만 비효율적이고 속도가 느린 전력 공급 구조다.

#### (2) 내부 전원 링(Internal Power Ring)을 이용하는 방법

이러한 문제를 해결하기 위해,
현대의 ASIC 설계에서는 외부 전원 링(External Power Ring) 대신
내부 전원 링(Internal Power Ring) 구조를 사용한다.

즉, 전원 공급을 위한 금속 링을 칩 외곽에 따로 두지 않고,
각 패드(pad) 내부에 전원선이 포함되어 있다.

이 내부 전원 링은 이미 다음과 같은 전원 신호선을 포함한다:

* DVDD : 레벨 시프터용 고전압 전원
* DVSS : 레벨 시프터용 접지
* VDD : 내부 로직용 전원
* VSS : 공용 접지

이 패드가 인접한 다른 전원 패드와 연결되면,
각 패드 내부에 내장된 이 전원 링 구조들이 자동으로 이어진다.
즉, 수평 방향으로 배치된 패드들이 서로 닿으면
그 내부의 전원 링들이 물리적으로 하나로 연결되는 것이다.

이 내부 전원 링 방식을 사용하면 다음과 같은 장점이 있다.

1. 외부 전원 링이 필요 없으므로 면적 절약(area saving)
   → 외곽에 별도의 금속층을 배치하지 않아도 된다.
2. 전력 전달 경로가 짧아져 전압 강하가 줄어듦
   → 전류 공급이 빠르고 효율적이다.
3. 인접 패드 간의 전력 및 접지 공유가 쉬움
   → 전원 공급의 일관성과 신뢰성이 높아진다.

즉, 내부 전원 링 구조는 공간 효율적이고, 빠른 전력 전달이 가능한 현대적인 방법이다.

#### Corner Cell and IO Filler

또 다른 문제는 칩의 모서리(corner)에서 발생한다.
칩의 모서리 부분에서는 일반적인 패드(pad) 형태를 그대로 사용할 수 없다.
모서리는 직선 형태가 아니라 꺾여 있기 때문이다.

이를 해결하기 위해 사용하는 것이 코너 셀(Corner Cell)이다.

예를 들어 보자.
내부 전원 링(internal power ring)이 사각형 형태로 이어져 있다고 가정하자.
만약 IO 필러(IO Filler)가 없이
패드들만 배치되어 있다면,
전원선(VDD, VSS 등)들은 서로 연결되지 않아
전기적 단절(open) 상태가 된다.

하지만 IO 필러를 추가하면,
그 내부에는 이미 정의된 전원선 패턴(predefined internal ring)이 포함되어 있어
인접한 두 패드의 내부 전원 링이 자동으로 이어진다.

그런데 모서리 구간에서는 단순히 IO 필러만으로는
전원선의 방향이 꺾이는 부분을 연결할 수 없다.
이럴 때 사용하는 것이 바로 코너 셀(Corner Cell)이다.
코너 셀은 수직(vertical)·수평(horizontal) 방향의
내부 전원 링을 90도로 연결해주는 역할을 한다.

즉,

* IO 필러(IO Filler) → 패드 간 직선 구간의 전원 연결
* 코너 셀(Corner Cell) → 모서리 구간의 전원 연결

이 두 가지를 함께 사용하면
칩 전체의 내부 전원 링(internal power ring)을
연속적이고 안정적으로 구성할 수 있다.

내부 신호 패드(signal pad)나 전원 패드(power pad)를 서로 연결하기 위해
두 가지 요소가 사용된다.
바로 IO 필러(IO Filler)와 코너 셀(Corner Cell)이다.

이 두 블록은 모두 논리적인 기능(logic functionality)을 가지지 않는다.
오직 내부 전원 링(internal power ring)의 연결만을 담당한다.

즉, 이들의 역할은 매우 단순하다.
→ 인접한 패드 간에 VDD(전원)와 VSS(접지) 정보를 전달하여
칩 전체의 전원망이 끊기지 않도록 이어주는 것이다.

내부 전원 링의 실제 형태를 보면 다음과 같다.

* 메인 패드(Main Pad)들 사이에는
  IO 필러(IO Filler)가 배치되어 있어
  내부 전원 링(VDD/VSS Line)이 연속적으로 연결된다.

* 코너 영역(Corner)에서는
  코너 셀(Corner Cell)이 추가되어
  북쪽(North) 방향과 서쪽(West) 방향의
  전원선을 서로 연결해준다.

결과적으로, IO 필러와 코너 셀을 함께 사용하면
칩의 사각형 외곽을 따라
전원(VDD)과 접지(VSS)가 완전히 닫힌 형태의
연속적인 내부 전원 링(integrated internal power ring)으로 구성된다.