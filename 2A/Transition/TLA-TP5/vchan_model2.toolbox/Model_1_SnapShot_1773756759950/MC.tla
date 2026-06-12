---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375675781957000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375675781958000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375675781959000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375675781960000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375675781961000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 15:12:37 CET 2026 by abi7287
