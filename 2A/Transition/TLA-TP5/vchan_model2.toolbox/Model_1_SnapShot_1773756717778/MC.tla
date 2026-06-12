---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375671664647000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375671664648000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375671664649000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375671664650000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375671664651000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 15:11:56 CET 2026 by abi7287
