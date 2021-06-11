function gxbprint(io::IO, x, name = "", level::libgb.GxB_Print_Level = libgb.GxB_SUMMARY)
    str = mktemp() do _, f
        cf = Libc.FILE(f)
        if x isa AbstractGBType
            libgb.GxB_Type_fprint(x, name, level, cf)
        elseif x isa libgb.GrB_UnaryOp
            libgb.GxB_UnaryOp_fprint(x, name, level, cf)
        elseif x isa libgb.GrB_BinaryOp
            libgb.GxB_BinaryOp_fprint(x, name, level, cf)
        elseif x isa SelectUnion
            libgb.GxB_SelectOp_fprint(x, name, level, cf)
        elseif x isa libgb.GrB_Semiring
            libgb.GxB_Semiring_fprint(x, name, level, cf)
        elseif x isa AbstractDescriptor
            libgb.GxB_Descriptor_fprint(x, name, level, cf)
        end
        flush(f)
        seekstart(f)
        x = read(f, String)
        close(cf)
        x
    end
    replace(str, "\n" => "")
    print(io, str[4:end])
end
