---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375652613932000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375652613933000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375652613934000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375652613935000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375652614036000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 15:08:46 CET 2026 by abi7287
