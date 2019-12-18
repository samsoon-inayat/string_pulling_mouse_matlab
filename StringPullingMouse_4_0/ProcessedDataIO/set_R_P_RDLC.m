function [R,P,RDLC] = set_R_P_RDLC (handles,R,P,RDLC,saveFlag)

pd = get_processed_data(handles);
if isnumeric(R)
    pd.R = R;
    if saveFlag
        pd.resultsMF.R = R;
    end
end
if isnumeric(P)
    pd.P = P;
    if saveFlag
        pd.resultsMF.P = P;
    end
end
if isnumeric(RDLC)
    pd.RDLCS = RDLC;
    if saveFlag
        pd.resultsDLCMF.R = RDLC;
    end
end
set_processed_data(handles,pd);

