class ToyLang
macro
	BLANK		\s+
	REM_IN		\/\*
	REM_OUT		\*\/
	REM 		\/\/
rule
# remark
			{REM_IN}		{ state = :REMS; [:rem_in, text] }
:REMS		{REM_OUT}		{ state = nil;   [:rem_out, text] }
:REMS		.*(?={REM_OUT})	{				 [:remark, text] }
			{REM}			{ state = :REM;	 [:rem_in, text] }
:REM 		\n 				{ state = nil;   [:rem_out, text] }
:REM  		.*(?=$)			{ 				 [:remark, text] }
# skip
			{BLANK}			#no action
			print			{ [:tprint, text] }
			return			{ [:treturn, text] }
			int				{ [:typeint, text] }
			double			{ [:typedbl, text] }
			[a-zA-Z_][a-zA-Z0-9_]* { [:identifier, text] }
			\d+\.[\d]+		{ [:double, text.to_f] }
			\d+				{ [:integer, text.to_i] }
			=				{ [:tequal, text] }
			==				{ [:tceq, text] }
			!=				{ [:tcne, text] }
			<				{ [:tclt, text] }
			<=				{ [:tcle, text] }
			>				{ [:tcgt, text] }
			>=				{ [:tcge, text] }
			\(				{ [:tlparen, text] }
			\)				{ [:trparen, text] }
			{				{ [:tlbrace, text] }
			}				{ [:trbrace, text] }
			,				{ [:tcomma, text] }
			\+				{ [:tplus, text] }
			-				{ [:tminus, text] }
			\*				{ [:tmul, text] }
			\/				{ [:tdiv, text] }
			%				{ [:tmod, text] }
			\.				{ [:tdot, text] }

inner 
end