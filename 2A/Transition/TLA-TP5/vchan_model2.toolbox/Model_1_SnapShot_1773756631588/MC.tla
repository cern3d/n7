---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375662947642000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375662947643000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375662947644000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375662947645000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375662947646000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 15:10:29 CET 2026 by abi7287
