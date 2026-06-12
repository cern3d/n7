---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375530927522000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375530927523000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375530927524000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375530927525000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375530927526000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 14:48:29 CET 2026 by abi7287
