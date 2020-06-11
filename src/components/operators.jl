import Tokenize.Tokens: isoperator
precedence(op::Int) = op < Tokens.end_assignments ?  AssignmentOp :
                       op < Tokens.end_pairarrow ? 2 :
                       op < Tokens.end_conditional ? ConditionalOp :
                       op < Tokens.end_arrow ?       ArrowOp :
                       op < Tokens.end_lazyor ?      LazyOrOp :
                       op < Tokens.end_lazyand ?     LazyAndOp :
                       op < Tokens.end_comparison ?  ComparisonOp :
                       op < Tokens.end_pipe ?        PipeOp :
                       op < Tokens.end_colon ?       ColonOp :
                       op < Tokens.end_plus ?        PlusOp :
                       op < Tokens.end_bitshifts ?   BitShiftOp :
                       op < Tokens.end_times ?       TimesOp :
                       op < Tokens.end_rational ?    RationalOp :
                       op < Tokens.end_power ?       PowerOp :
                       op < Tokens.end_decl ?        DeclarationOp :
                       op < Tokens.end_where ?       WhereOp : DotOp

precedence(kind::Tokens.Kind) = kind === Tokens.DDDOT ? DddotOp :
                        kind < Tokens.begin_assignments ? 0 :
                        kind < Tokens.end_assignments ?   AssignmentOp :
                        kind < Tokens.end_pairarrow ?   2 :
                       kind < Tokens.end_conditional ?    ConditionalOp :
                       kind < Tokens.end_arrow ?          ArrowOp :
                       kind < Tokens.end_lazyor ?         LazyOrOp :
                       kind < Tokens.end_lazyand ?        LazyAndOp :
                       kind < Tokens.end_comparison ?     ComparisonOp :
                       kind < Tokens.end_pipe ?           PipeOp :
                       kind < Tokens.end_colon ?          ColonOp :
                       kind < Tokens.end_plus ?           PlusOp :
                       kind < Tokens.end_bitshifts ?      BitShiftOp :
                       kind < Tokens.end_times ?          TimesOp :
                       kind < Tokens.end_rational ?       RationalOp :
                       kind < Tokens.end_power ?          PowerOp :
                       kind < Tokens.end_decl ?           DeclarationOp :
                       kind < Tokens.end_where ?          WhereOp :
                       kind < Tokens.end_dot ?            DotOp :
                       kind === Tokens.ANON_FUNC ? AnonFuncOp :
                       kind === Tokens.PRIME ?             PrimeOp : 20

precedence(x) = 0
precedence(x::AbstractToken) = precedence(kindof(x))
precedence(x::EXPR) = error()#precedence(kindof(x))

isoperator(x) = false
isoperator(t::AbstractToken) = isoperator(kindof(t))
isoperator(x::EXPR) = headof(x) === :OPERATOR


isunaryop(op) = false
isunaryop(op::EXPR) = isoperator(op) && (valof(op) == "<:" || valof(op) == ">:" || valof(op) == "+" || valof(op) == "-" || valof(op) == "!" || valof(op) == "~" || valof(op) == "¬" || valof(op) == "&" || valof(op) == "√" || valof(op) == "∛"  || valof(op) == "∜"  || valof(op) == "::" || valof(op) == "\$" || valof(op) == ":" || valof(op) == "⋆")
isunaryop(t::AbstractToken) = isunaryop(kindof(t))
@static if VERSION < v"1.2.0"
    isunaryop(kind::Tokens.Kind) = kind === Tokens.ISSUBTYPE ||
                    kind === Tokens.ISSUPERTYPE ||
                    kind === Tokens.PLUS ||
                    kind === Tokens.MINUS ||
                    kind === Tokens.NOT ||
                    kind === Tokens.APPROX ||
                    kind === Tokens.NOT_SIGN ||
                    kind === Tokens.AND ||
                    kind === Tokens.SQUARE_ROOT ||
                    kind === Tokens.CUBE_ROOT ||
                    kind === Tokens.QUAD_ROOT ||
                    kind === Tokens.DECLARATION ||
                    kind === Tokens.EX_OR ||
                    kind === Tokens.COLON
else
    isunaryop(kind::Tokens.Kind) = kind === Tokens.ISSUBTYPE ||
                    kind === Tokens.ISSUPERTYPE ||
                    kind === Tokens.PLUS ||
                    kind === Tokens.MINUS ||
                    kind === Tokens.NOT ||
                    kind === Tokens.APPROX ||
                    kind === Tokens.NOT_SIGN ||
                    kind === Tokens.AND ||
                    kind === Tokens.SQUARE_ROOT ||
                    kind === Tokens.CUBE_ROOT ||
                    kind === Tokens.QUAD_ROOT ||
                    kind === Tokens.DECLARATION ||
                    kind === Tokens.EX_OR ||
                    kind === Tokens.COLON ||
                    kind === Tokens.STAR_OPERATOR
end

isunaryandbinaryop(t) = false
isunaryandbinaryop(t::AbstractToken) = isunaryandbinaryop(kindof(t))
@static if VERSION < v"1.2.0"
    isunaryandbinaryop(kind::Tokens.Kind) = kind === Tokens.PLUS ||
                            kind === Tokens.MINUS ||
                            kind === Tokens.EX_OR ||
                            kind === Tokens.ISSUBTYPE ||
                            kind === Tokens.ISSUPERTYPE ||
                            kind === Tokens.AND ||
                            kind === Tokens.APPROX ||
                            kind === Tokens.DECLARATION ||
                            kind === Tokens.COLON
else
    isunaryandbinaryop(kind::Tokens.Kind) = kind === Tokens.PLUS ||
                            kind === Tokens.MINUS ||
                            kind === Tokens.EX_OR ||
                            kind === Tokens.ISSUBTYPE ||
                            kind === Tokens.ISSUPERTYPE ||
                            kind === Tokens.AND ||
                            kind === Tokens.APPROX ||
                            kind === Tokens.DECLARATION ||
                            kind === Tokens.COLON ||
                            kind === Tokens.STAR_OPERATOR
end

isbinaryop(op) = false
isbinaryop(op::EXPR) = isoperator(op) && !(valof(op) == "√" ||
    valof(op) == "∛" ||
    valof(op) == "∜" ||
    valof(op) == "!" ||
    valof(op) == "¬")
isbinaryop(t::AbstractToken) = isbinaryop(kindof(t))
isbinaryop(kind::Tokens.Kind) = isoperator(kind) &&
                    !(kind === Tokens.SQUARE_ROOT ||
                    kind === Tokens.CUBE_ROOT ||
                    kind === Tokens.QUAD_ROOT ||
                    kind === Tokens.NOT ||
                    kind === Tokens.NOT_SIGN)

function non_dotted_op(t::AbstractToken)
    k = kindof(t)
    return (k === Tokens.COLON_EQ ||
            k === Tokens.PAIR_ARROW ||
            k === Tokens.EX_OR_EQ ||
            k === Tokens.CONDITIONAL ||
            k === Tokens.LAZY_OR ||
            k === Tokens.LAZY_AND ||
            k === Tokens.ISSUBTYPE ||
            k === Tokens.ISSUPERTYPE ||
            k === Tokens.LPIPE ||
            k === Tokens.RPIPE ||
            k === Tokens.EX_OR ||
            k === Tokens.COLON ||
            k === Tokens.DECLARATION ||
            k === Tokens.IN ||
            k === Tokens.ISA ||
            k === Tokens.WHERE ||
            (isunaryop(k) && !isbinaryop(k) && !(k === Tokens.NOT)))
end
isdotted(x::EXPR) = valof(x) isa String && length(valof(x)) > 1 && valof(x)[1] === '.' && !(valof(x) == "..." || valof(x) == "..")

issyntaxcall(op) = false
function issyntaxcall(op::EXPR)
    v = valof(op)
    if v[1] == '.' && length(v) > 1 && assign_prec(v[2:end])
        return true
    end
    assign_prec(v) && !(v == "~" || v== "=>") ||
    v == "-->" ||
    v == "||" ||
    v == "&&" ||
    v == "<:" ||
    v == ">:" ||
    v == ":" ||
    v == "::" ||
    v == "." ||
    v == "..." ||
    v == "'" ||
    v == "where" ||
    v == "->"
end


issyntaxunarycall(op) = false
function issyntaxunarycall(op::EXPR)
    v = valof(op)
    !isdotted(op) && (v == "\$" || v == "&" || v == "::" || v == "..." || v == "'" || v == "<:" || v == ">:")
end



LtoR(prec::Int) = AssignmentOp ≤ prec ≤ LazyAndOp || prec == PowerOp


"""
    parse_unary(ps)

Having hit a unary operator at the start of an expression return a call.
"""
function parse_unary(ps::ParseState, op::EXPR)
    dot = isdotted(op)
    if is_colon(op)
        ret = parse_unary_colon(ps, op)
    elseif should_negate_number_literal(ps, op)
        arg = mLITERAL(next(ps))
        ret = EXPR(literalmap(kindof(ps.t)), op.fullspan + arg.fullspan, (op.fullspan + arg.span), string(is_plus(op) ? "+" : "-", val(ps.t, ps)))
    else
        prec = valof(op) == "::" ? DeclarationOp :
                valof(op) == "&" ? DeclarationOp :
                valof(op) == "\$" ? 20 : PowerOp
        arg = @closer ps :unary @precedence ps prec parse_expression(ps)
        if issyntaxunarycall(op)
            ret = EXPR(op, EXPR[arg], nothing)
        else
            ret = EXPR(:call, EXPR[op, arg], nothing)
        end
    end
    return ret
end

function parse_unary_colon(ps::ParseState, op::EXPR)
    op = requires_no_ws(op, ps)
    if Tokens.iskeyword(kindof(ps.nt))
        ret = EXPR(:quotenode, EXPR[EXPR(:IDENTIFIER, next(ps))], EXPR[op])
    elseif Tokens.begin_literal < kindof(ps.nt) < Tokens.CHAR ||
        isoperator(kindof(ps.nt)) || isidentifier(ps.nt) || kindof(ps.nt) === Tokens.TRUE || kindof(ps.nt) === Tokens.FALSE
        ret = EXPR(:quotenode, EXPR[INSTANCE(next(ps))], EXPR[op])
    elseif closer(ps)
        ret = op
    else
        prev_errored = ps.errored
        arg = @precedence ps 20 parse_expression(ps)
        if isbracketed(arg) && headof(arg.args[1]) === :errortoken && errorof(arg.args[1]) === UnexpectedAssignmentOp
            ps.errored = prev_errored
            arg.args[1] = arg.args[1].args[1]
            setparent!(arg.args[1], arg)
        end
        # TODO: need special conversion where arg is a n-bracketed terminal (not keywords)
        unwrapped = unwrapbracket(arg)
        if isoperator(unwrapped) || isidentifier(unwrapped) || isliteral(unwrapped)
            ret = EXPR(:quotenode, EXPR[arg], EXPR[op])
        else
            ret = EXPR(:quote, EXPR[arg], EXPR[op])
        end
    end
    return ret
end

function parse_operator_eq(ps::ParseState, ret::EXPR, op::EXPR)
    nextarg = @precedence ps AssignmentOp - LtoR(AssignmentOp) parse_expression(ps)

    if is_func_call(ret) && !(isbeginorblock(nextarg))
        nextarg = EXPR(:block, EXPR[nextarg], nothing)
    end
    if issyntaxcall(op)
        ret = EXPR(op, EXPR[ret, nextarg], nothing)
    else
        ret = EXPR(:call, EXPR[op, ret, nextarg], nothing)
    end
    return ret
end

# Parse conditionals

isconditional(x::EXPR) = headof(x) === :if && hastrivia(x) && isoperator(first(x.trivia))
function parse_operator_cond(ps::ParseState, ret::EXPR, op::EXPR)
    ret = requires_ws(ret, ps)
    op = requires_ws(op, ps)
    nextarg = @closer ps :ifop parse_expression(ps)
    if kindof(ps.nt) !== Tokens.COLON
        op2 = mErrorToken(ps, EXPR(:OPERATOR, 0, 0, ":"), MissingColon)
        nextarg2 = mErrorToken(ps, Unknown)
        return EXPR(:if, EXPR[ret, nextarg, nextarg2], EXPR[op, op2])
    else
        op2 = requires_ws(EXPR(:OPERATOR, next(ps)), ps)
    end

    nextarg2 = @closer ps :comma @precedence ps 0 parse_expression(ps)

    return EXPR(:if, EXPR[ret, nextarg, nextarg2], EXPR[op, op2])
end

# Parse comparisons
function parse_comp_operator(ps::ParseState, ret::EXPR, op::EXPR)
    nextarg = @precedence ps ComparisonOp - LtoR(ComparisonOp) parse_expression(ps)

    if headof(ret) === :comparison
        push!(ret, op)
        push!(ret, nextarg)
    elseif can_become_comparison(ret)
        if isoperator(headof(ret))
            ret = EXPR(:comparison, EXPR[ret.args[1], ret.head, ret.args[2], op, nextarg], nothing)
        else
            ret = EXPR(:comparison, EXPR[ret.args[2], ret.args[1], ret.args[3], op, nextarg], nothing)
        end
    elseif issyntaxcall(op)
        ret = EXPR(op, EXPR[ret, nextarg], nothing)
    else
        ret = EXPR(:call, EXPR[op, ret, nextarg], nothing)
    end
    return ret
end

# Parse ranges
function parse_operator_colon(ps::ParseState, ret::EXPR, op::EXPR)
    if isnewlinews(ps.ws) && !ps.closer.paren
        op = mErrorToken(ps, op, UnexpectedNewLine)
    end
    nextarg = @precedence ps ColonOp - LtoR(ColonOp) parse_expression(ps)

    if isbinarycall(ret) && is_colon(ret.args[1])
        ret.trivia = EXPR[]
        pushtotrivia!(ret, op)
        push!(ret, nextarg)
    else
        ret = EXPR(:call, EXPR[op, ret, nextarg], nothing)
    end
    return ret
end

# Parse power (special case for preceding unary ops)
function parse_operator_power(ps::ParseState, ret::EXPR, op::EXPR)
    nextarg = @precedence ps PowerOp - LtoR(PowerOp) @closer ps :inwhere parse_expression(ps)

    if isunarycall(ret)
        # TODO: this smells wrong
        nextarg = EXPR(:call, EXPR[op, ret.args[2], nextarg], nothing)
        ret = EXPR(:call, EXPR[ret.args[1], nextarg], nothing)
    else
        ret = EXPR(:call, EXPR[op, ret, nextarg], nothing)
    end
    return ret
end

# parse where
function parse_operator_where(ps::ParseState, ret::EXPR, op::EXPR, setscope = true)
    nextarg = @precedence ps LazyAndOp @closer ps :inwhere parse_expression(ps)
    if headof(nextarg) === :braces
        pushfirst!(nextarg.args, ret)
        pushfirst!(nextarg.trivia, op)
        ret = EXPR(:Where, nextarg.args,nextarg.trivia)
    else
        ret = EXPR(:Where, EXPR[ret, nextarg], EXPR[op])
    end
    return ret
end

function parse_operator_dot(ps::ParseState, ret::EXPR, op::EXPR)
    if kindof(ps.nt) === Tokens.LPAREN
        @static if VERSION > v"1.1-"
            iserred = kindof(ps.ws) != Tokens.EMPTY_WS
            sig = @default ps parse_call(ps, ret)
            nextarg = EXPR(:tuple, sig.args[2:end], sig.trivia)
            if iserred
                nextarg = mErrorToken(ps, nextarg, UnexpectedWhiteSpace)
            end
        else
            sig = @default ps parse_call(ps, ret)
            nextarg = EXPR(:tuple, sig.args[2:end], sig.trivia)
        end
    elseif iskeyword(ps.nt) || both_symbol_and_op(ps.nt)
        nextarg = EXPR(:IDENTIFIER, next(ps))
    elseif kindof(ps.nt) === Tokens.COLON
        op2 = EXPR(:OPERATOR, next(ps))
        if kindof(ps.nt) === Tokens.LPAREN
            nextarg = @closeparen ps @precedence ps DotOp - LtoR(DotOp) parse_expression(ps)
            nextarg = EXPR(:quotenode, EXPR[nextarg], EXPR[op2])
        else
            nextarg = @precedence ps DotOp - LtoR(DotOp) parse_unary(ps, op2)
        end
    elseif kindof(ps.nt) === Tokens.EX_OR && kindof(ps.nnt) === Tokens.LPAREN
        op2 = EXPR(:OPERATOR, next(ps))
        nextarg = parse_call(ps, op2)
    else
        nextarg = @precedence ps DotOp - LtoR(DotOp) parse_expression(ps)
    end

    if isidentifier(nextarg) || isinterpolant(nextarg)
        ret = EXPR(op, EXPR[ret, EXPR(:quotenode, EXPR[nextarg], nothing)], nothing)
    elseif headof(nextarg) === :vect || headof(nextarg) === :braces
        ret = EXPR(op, EXPR[ret, EXPR(:quote, EXPR[nextarg], nothing)], nothing)
    elseif headof(nextarg) === :macrocall
        # TODO : ?
        mname = EXPR(op, EXPR[ret, EXPR(:quotenode, EXPR[nextarg.args[1]], nothing)], nothing)
        ret = EXPR(:macrocall, EXPR[mname], nothing)
        for i = 2:length(nextarg.args)
            push!(ret, nextarg.args[i])
        end
    else
        ret = EXPR(op, EXPR[ret, nextarg], nothing)
    end
    return ret
end

function parse_operator_anon_func(ps::ParseState, ret::EXPR, op::EXPR)
    arg = @closer ps :comma @precedence ps 0 parse_expression(ps)
    if !isbeginorblock(arg)
        arg = EXPR(:block, EXPR[arg], nothing)
    end
    return EXPR(op, EXPR[ret, arg], nothing)
end

function parse_operator(ps::ParseState, ret::EXPR, op::EXPR)
    dot = isdotted(op)
    P = isdotted(op) ? AllPrecs[valof(op)[2:end]] : AllPrecs[valof(op)]

    if headof(ret) === :call && (is_plus(ret.args[1]) || is_star(ret.args[1])) && valof(ret.args[1]) == valof(op) && ret.args[1].span > 0
        # a + b -> a + b + c
        nextarg = @precedence ps P - LtoR(P) parse_expression(ps)
        !hastrivia(ret) && (ret.trivia = EXPR[])
        pushtotrivia!(ret, op)
        push!(ret, nextarg)
        ret = ret
    elseif can_become_chain(ret, op)
        # TODO: redundant?
        nextarg = @precedence ps P - LtoR(P) parse_expression(ps)
        ret = EXPR(:chainopcall, EXPR[ret.args[1], ret.args[2], ret.args[3], op, nextarg])
    elseif is_eq(op)
        ret = parse_operator_eq(ps, ret, op)
    elseif is_cond(op)
        ret = parse_operator_cond(ps, ret, op)
    elseif is_colon(op)
        ret = parse_operator_colon(ps, ret, op)
    elseif is_where(op)
        ret = parse_operator_where(ps, ret, op)
    elseif is_anon_func(op)
        ret = parse_operator_anon_func(ps, ret, op)
    elseif is_dot(op)
        ret = parse_operator_dot(ps, ret, op)
    elseif is_dddot(op) || is_prime(op)
        ret = EXPR(op, EXPR[ret], nothing)
    elseif P == ComparisonOp
        ret = parse_comp_operator(ps, ret, op)
    elseif P == PowerOp
        ret = parse_operator_power(ps, ret, op)
    else
        ltor = valof(op) == "<|" ? true : LtoR(P)
        nextarg = @precedence ps P - ltor parse_expression(ps)
        if issyntaxcall(op)
            ret = EXPR(op, EXPR[ret, nextarg], nothing)
        else
            ret = EXPR(:call, EXPR[op, ret, nextarg], nothing)
        end
    end
    return ret
end

assign_prec(op) = get(AllPrecs, op, 0) === AssignmentOp
comp_prec(op) = get(AllPrecs, op, 0) === ComparisonOp

const AllPrecs = Dict("≏" => 9,"⤎" => 3,"<:" => 6,"⫌" => 6,"⇀" => 0,"≁" => 6,"⧀" => 6,"⪎" => 6,"⪱" => 6,"↬" => 0,"⇝" => 0,"⩳" => 6,"⪻" => 6,"//" => 11,"⬿" => 3,"⊅" => 6,"⋳" => 6,"≮" => 6,"\$=" => 1,"≗" => 6,"⋗" => 6,"⩊" => 9,"⪵" => 6,"⋟" => 6,"⤠" => 3,"≵" => 6,"⧁" => 6,"≫" => 6,"⩫" => 6,"⪸" => 6,"⊓" => 10,"⭄" => 3,"⇁" => 0,"≀" => 10,"⪚" => 6,"∷" => 6,"⥪" => 3,"⥔" => 13,"⊻" => 9,"⩯" => 6,"↷" => 0,"⇿" => 3,"⪉" => 6,"⊰" => 6,"⨟" => 0,"⩻" => 6,"⭋" => 3,"⩒" => 9,"-" => 9,"⫸" => 6,"⤒" => 13,"+=" => 1,"↦" => 3,"⊜" => 6,"|>" => 7,"⩀" => 10,"⪫" => 6,"≡" => 6,"⋹" => 6,"⤑" => 3,"⥐" => 3,"≭" => 6,"≼" => 6,"⥇" => 3,"⋶" => 6,"⨸" => 10,"⩽" => 6,"⪐" => 6,"⨥" => 9,"∊" => 6,"⪙" => 6,"⥢" => 3,"⅋" => 10,"⫘" => 6,"⊂" => 6,"⩸" => 6,"⩄" => 10,"⤞" => 3,"⫍" => 6,"⨢" => 9,"⊄" => 6,"≯" => 6,"===" => 6,"⬺" => 3,"⪛" => 6,"⋡" => 6,"⫀" => 6,"⨣" => 9,"↞" => 0,"⟾" => 3,"⊬" => 6,"⇌" => 0,"≷" => 6,"∓" => 9,"⪶" => 6,"⊀" => 6,"⊛" => 10,"⋠" => 6,"↢" => 0,"⥦" => 3,"⪪" => 6,"⋌" => 10,"⪅" => 6,"≿" => 6,">>=" => 1,"\$" => 9,"≽" => 6,"⪟" => 6,"⋆" => 10,"±" => 9,"⋴" => 6,"⥧" => 3,"/" => 10,"⥕" => 13,"." => 16,"⩢" => 9,"⟖" => 10,"⪗" => 6,"≓" => 6,"⋨" => 6,"⥜" => 13,"⪊" => 6,"⨽" => 10,"⪦" => 6,"≱" => 6,"⧷" => 10,">>" => 12,"⊏" => 6,"⬴" => 3,"⪴" => 6,"⁝" => 8,"⤘" => 3,"⩜" => 10,"￬" => 13,"∤" => 10,"⩲" => 6,"⫙" => 6,"⇵" => 13,"⤗" => 3,"⪀" => 6,"⩬" => 6,"↫" => 0,"&" => 10,"⩺" => 6,"↚" => 3,"⨇" => 10,"⋭" => 6,"≐" => 6,"∩" => 10,"↓" => 13,"⪓" => 6,"≦" => 6,"=" => 1,"∧" => 10,"⇇" => 0,"≖" => 6,"⇸" => 3,"⋙" => 6,"≚" => 6,"⇴" => 3,"⬲" => 3,"⥙" => 13,"⋢" => 6,"⫹" => 6,"⩛" => 9,"⋿" => 6,"⪑" => 6,"⭉" => 3,"⋎" => 9,"⋋" => 10,"⇋" => 0,"≴" => 6,"…" => 8,"⪰" => 6,"↺" => 0,"⪖" => 6,"⨦" => 9,"⬼" => 3,"⤐" => 3,"⊗" => 10,"⨮" => 9,"⊚" => 10,"⥈" => 3,"≣" => 6,"⋫" => 6,"≺" => 6,"⇽" => 3,"⬳" => 3,"⥨" => 3,"⋽" => 6,"⩟" => 10,"⋞" => 6,"⩖" => 9,"⧥" => 6,"⨝" => 10,"⪕" => 6,"⊟" => 9,"⋑" => 6,"⊲" => 6,"≟" => 6,"⫈" => 6,"⥋" => 3,"⩂" => 9,"⥏" => 13,"⥩" => 3,"⥑" => 13,"⪤" => 6,"⫖" => 6,"×" => 10,"÷=" => 1,"⋪" => 6,"⫓" => 6,"⫄" => 6,"⊋" => 6,"⇆" => 0,"⤌" => 3,"⟹" => 3,"⊖" => 9,"⫏" => 6,"⫷" => 6,"⪜" => 6,"⊕" => 9,"%=" => 1,"⊍" => 10,"⨤" => 9,"≃" => 6,"⩪" => 6,"⤉" => 13,"⪽" => 6,"⋓" => 9,"⤀" => 3,"∺" => 6,"⤆" => 3,"⊳" => 6,"//=" => 1,"≒" => 6,"⩦" => 6,"↶" => 0,"⊡" => 10,"⟈" => 6,"≩" => 6,"||" => 4,"↠" => 3,"⥒" => 3,"⨧" => 9,"⪧" => 6,"⨪" => 9,"⇹" => 3,"⥛" => 3,"↣" => 3,"⫁" => 6,"⭊" => 3,"⋜" => 6,"⪳" => 6,"⋼" => 6,"⥍" => 13,"⫎" => 6,"^=" => 1,"⪢" => 6,"∪" => 9,"⩅" => 9,"⬵" => 3,"⬽" => 3,"≬" => 6,"⧶" => 10,"⪡" => 6,"≶" => 6,"⇼" => 3,"^" => 13,"⇷" => 3,"⋸" => 6,"⊩" => 6,"⭀" => 3,"⧴" => 3,"⊷" => 6,"⤔" => 3,"~" => 1,"⫒" => 6,"⩼" => 6,"⧺" => 9,"⧻" => 9,">>>=" => 1,"⪂" => 6,"⨻" => 10,"⤏" => 3,"⥘" => 13,"≕" => 6,"⥓" => 3,"⨰" => 10,"⨺" => 9,"⟵" => 3,"⇜" => 0,"<<=" => 1,"≔" => 6,"⩋" => 10,"⫊" => 6,"⪠" => 6,"⥬" => 3,"⥖" => 3,"⪣" => 6,"↔" => 3,"≥" => 6,"⧤" => 6,"⤄" => 3,"⊢" => 6,"⋛" => 6,"⩔" => 9,"⇶" => 3,"⤇" => 3,"⟽" => 3,"⩵" => 6,"⬶" => 3,"⩌" => 9,"↮" => 3,"⪾" => 6,"⋕" => 6,"⥤" => 3,"∋" => 6,"↽" => 0,"⋇" => 10,"⪍" => 6,"⩃" => 10,"⨈" => 9,"⋚" => 6,"⩐" => 9,"≾" => 6,"⋤" => 6,"∔" => 9,"⤈" => 13,"⇾" => 3,"⊮" => 6,"⪩" => 6,"⬷" => 3,"|++|" => 9,"↪" => 0,"⭇" => 3,"⨨" => 9,"⩓" => 10,"⤊" => 13,"↤" => 0,"⊱" => 6,"⟼" => 3,"⨴" => 10,"⤋" => 13,"⊴" => 6,"≊" => 6,"⧡" => 6,"⫆" => 6,"⋯" => 8,"≜" => 6,"∍" => 6,"::" => 14,"⥣" => 13,"⪃" => 6,"⪹" => 6,"⩴" => 6,"⥫" => 3,"￫" => 3,">>>" => 12,"≢" => 6,"⊈" => 6,"≤" => 6,"⟿" => 3,"⪨" => 6,"⋖" => 6,"⫉" => 6,"⩹" => 6,"￪" => 13,"⊆" => 6,"!==" => 6,"⪔" => 6,"⥎" => 3,"≋" => 6,"⊁" => 6,"⋥" => 6,"⋉" => 10,"⨱" => 10,"?" => 2,"⥚" => 3,"⋷" => 6,"⟒" => 6,"⫅" => 6,"⪏" => 6,"⩕" => 10,"⪞" => 6,">:" => 6,"⟗" => 10,"⪷" => 6,"⩎" => 10,"⬱" => 3,"⇺" => 3,"⩁" => 9,"⥆" => 3,"⊘" => 10,"⨼" => 10,"⊙" => 10,"⊇" => 6,"⋍" => 6,"≛" => 6,"⊒" => 6,"⋏" => 10,"⭁" => 3,"⤂" => 3,"⥄" => 3,"⋝" => 6,"÷" => 10,"⧣" => 6,"⊞" => 9,"⬾" => 3,"⇉" => 0,"⨶" => 10,"in" => 6,"==" => 6,"⟶" => 3,"⬰" => 3,":=" => 1,"⪋" => 6,"≂" => 9,"<|" => 7,"⥊" => 3,"⪺" => 6,"≎" => 6,"≈" => 6,"∌" => 6,"⨹" => 9,"⪘" => 6,"⨵" => 10,"⦾" => 10,"⇒" => 3,".." => 8,"⇛" => 0,"⪿" => 6,"≹" => 6,"⋱" => 8,"⇎" => 3,"→" => 3,"⥮" => 13,"-=" => 1,"<" => 6,"⪇" => 6,"⥗" => 3,"⪈" => 6,"⨫" => 9,"⥞" => 3,"⭂" => 3,"⩠" => 10,"\\" => 10,"⩿" => 6,"↑" => 13,"≳" => 6,"⋧" => 6,"⩧" => 6,"--" => 0,"⪮" => 6,"⪄" => 6,"⊎" => 9,"⩾" => 6,"↝" => 0,"⨲" => 10,"⊐" => 6,"⟻" => 3,"⫗" => 6,"⩞" => 10,"⥯" => 13,"⪌" => 6,"≨" => 6,"⋄" => 10,"⪯" => 6,"⦸" => 10,"⫐" => 6,"↜" => 0,"≧" => 6,"∉" => 6,"⤟" => 3,"⋾" => 6,"￩" => 3,"<<" => 12,"≞" => 6,"⩍" => 10,"⇄" => 0,"▷" => 10,"⋘" => 6,"≇" => 6,"⇏" => 3,"⊶" => 6,"⫇" => 6,"*" => 10,"⩣" => 9,"⬸" => 3,"⥥" => 13,"≙" => 6,"*=" => 1,"≄" => 6,"⊑" => 6,"⫑" => 6,"⩗" => 9,"⟷" => 3,"⟱" => 13,"≻" => 6,"⋲" => 6,"≑" => 6,"⭈" => 3,"∾" => 6,"&=" => 1,"≪" => 6,"\\\\=" => 10,"↼" => 0,"⬹" => 3,"∗" => 10,"⊣" => 6,"⫺" => 6,"⥌" => 13,"⋩" => 6,"≲" => 6,"≝" => 6,"⊽" => 9,"/=" => 1,"⋬" => 6,"⩶" => 6,"⫛" => 10,"=>" => 2,"⪁" => 6,"⨩" => 9,"⥝" => 13,"⩝" => 9,"⟕" => 10,"⤖" => 3,"⥉" => 13,"⩏" => 9,"!=" => 6,"⨳" => 10,"≰" => 6,"⟂" => 6,"⋐" => 6,"\\=" => 1,"⤝" => 3,"⦷" => 6,"⊔" => 9,">" => 6,"⥰" => 3,"∽" => 6,"⋦" => 6,"⤅" => 3,"⫕" => 6,"⋺" => 6,"∈" => 6,"∙" => 10,"⥅" => 3,"⦼" => 10,"<=" => 6,"←" => 3,"isa" => 6,"⋻" => 6,"⫔" => 6,"⋵" => 6,"⋅" => 10,"⨷" => 10,"⟰" => 13,"∨" => 9,"≆" => 6,"⪥" => 6,"≍" => 6,"⪝" => 6,"⫂" => 6,"⊻=" => 1,"⨭" => 9,"⋒" => 10,"⦿" => 10,"≸" => 6,"⥡" => 13,"+" => 9,"⇻" => 3,"⥟" => 3,"⟉" => 6,"⊵" => 6,"⩰" => 6,"%" => 10,"⫃" => 6,"∸" => 9,"⋣" => 6,"-->" => 3,"∥" => 6,"∦" => 6,"⋮" => 8,"⪒" => 6,"⤃" => 3,"⟑" => 10,"⩑" => 10,"⋰" => 8,"⪬" => 6,"≠" => 6,"≅" => 6,"⊼" => 10,"⬻" => 3,"⩘" => 10,"⭃" => 3,"⥭" => 3,"⤕" => 3,"≘" => 6,"⇠" => 0,"⟺" => 3,"⪼" => 6,"⇢" => 0,"↩" => 0,"⋊" => 10,"&&" => 5,"⩚" => 10,"⩮" => 6,"⤓" => 13,"⥠" => 13,"⤁" => 3,"≌" => 6,"⭌" => 3,"⇐" => 0,":" => 8,"⇍" => 0,"⩭" => 6,"↛" => 3,"↻" => 0,"⪲" => 6,"⇔" => 3,"⪭" => 6,"⩱" => 6,"⤍" => 3,"⊃" => 6,"∝" => 6,"⊊" => 6,"⊠" => 10,"∘" => 10,"⇚" => 0,"⪆" => 6,"⫋" => 6,"|" => 9,"⊉" => 6,"∻" => 6,"≉" => 6,"⩡" => 9,"⨬" => 9,"⩷" => 6,">=" => 6, "..." => 0, "where" => WhereOp, "->" => AnonFuncOp, "|=" => 1)