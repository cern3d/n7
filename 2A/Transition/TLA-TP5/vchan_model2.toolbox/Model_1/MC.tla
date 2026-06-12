---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375820984862000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375820984863000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375820984864000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375820984865000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375820984866000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 15:36:49 CET 2026 by abi7287
