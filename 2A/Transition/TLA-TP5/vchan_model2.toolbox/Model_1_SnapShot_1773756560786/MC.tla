---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375655963637000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375655963638000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375655963639000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375655963640000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375655963641000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 15:09:19 CET 2026 by abi7287
