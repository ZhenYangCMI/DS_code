function AtlasInfo=w_GetAtlasInfo(Reference, Template, Alias)

AtlasInfo=load(Reference);
[Volume, Vox, Header]=y_ReadRPI(Template);
Header.Data=Volume;
Header.Vox=Vox;
Header.Alias=Alias;

ColorMap=colormap('cool');
% ColorMap = y_AFNI_ColorMap(12);
% ColorMap = y_AdjustColorMap(ColorMap,...
%     [0.75 0.75 0.75],...
%     0,...
%     0,...
%     0,...
%     1);

Header.CMap=ColorMap;

AtlasInfo.Template=Header;
