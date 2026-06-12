---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375529734317000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375529734318000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375529734419000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375529734420000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375529734421000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 14:48:17 CET 2026 by abi7287
