function [R,P,RDLC] = get_R_P_RDLC (handles)

pd = get_processed_data(handles);
R = pd.R;
P = pd.P;
RDLC = pd.RDLCS;
