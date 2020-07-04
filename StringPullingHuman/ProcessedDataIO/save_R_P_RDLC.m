function [R,P,RDLC] = save_R_P_RDLC (handles)

pd = get_processed_data(handles);
pd.resultsMF.R = pd.R;
pd.resultsMF.P = pd.P;
pd.resultsDLCMF.R = pd.RDLCS;
set_processed_data(handles,pd);

