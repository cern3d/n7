---- MODULE MC ----
EXTENDS vchan, TLC

\* CONSTANT definitions @modelParameterConstants:0MaxReadLen
const_177375673599152000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1MaxWriteLen
const_177375673599153000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:2BufferSize
const_177375673599154000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3Byte
const_177375673599155000 == 
1..5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_177375673599156000 ==
Len(Sent)<4
----
=============================================================================
\* Modification History
\* Created Tue Mar 17 15:12:15 CET 2026 by abi7287
