% Insert State

US_State='MD' % Maryland



%%%%% Read ERA5 grid

era5_file='D:/ERA5/1979/era5_197901.grib';

info = georasterinfo(era5_file);
metadata = info.Metadata;
band_t2m=find(info.Metadata.Element=='2T');
band_d2m=find(info.Metadata.Element=='2D');
band_sp=find(info.Metadata.Element=='SP');

[t2m,R] = readgeoraster(era5_file,Bands=band_t2m);
clear t2m

xax_era5=R.LongitudeLimits(1):R.SampleSpacingInLongitude:R.LongitudeLimits(end);
yax_era5=R.LatitudeLimits(end):-R.SampleSpacingInLatitude:R.LatitudeLimits(1);
clear R
xy=zeros(numel(yax_era5)*numel(xax_era5),2);
ij=zeros(numel(yax_era5)*numel(xax_era5),2);
ig=0;
for j=1:numel(yax_era5)
    for i=1:numel(xax_era5)
        ig=ig+1;
        xy(ig,1)=xax_era5(i);
        xy(ig,2)=yax_era5(j);
        ij(ig,1)=i;
        ij(ig,2)=j;
    end
end

%%%% END Read ERA5 Grid

%%%% Read US State boundaries
clear S A us_states_file01 us_states_file02 opts T ST ig1 
us_states_file01='D:/DATA/Geography/States_shapefile-shp/States_shapefile.shp';
[S,A]=shaperead(us_states_file01,'UseGeoCoords',true);

us_states_file02='D:/DATA/Geography/States_shapefile-shp/States_shapefile.csv';
opts = detectImportOptions(us_states_file02);
opts.SelectedVariableNames = ["State_Code","State_Name"];
T = readtable(us_states_file02,opts);
ST=table2array(T);

ig1=find(strcmp(T{:,1},US_State)==1)
plot(S(ig1).Lon,S(ig1).Lat)

%%%% END Define State Boundaries

%%% Find ERA5 grid points within state boundaries

clear in_state

in_state=find(inpolygon(xy(:,1),xy(:,2),S(ig1).Lon,S(ig1).Lat)==1);

%%% END find ERA5 grid points within Stata
rh_state=[];
qs_state=[];
t2m_state=[];

for iy=1979:2023
tic
iy
for im=1:12
clear era5_file infor metadata t2m d2m sp

era5_file=['D:/ERA5/',num2str(iy),'/era5_',num2str(iy), sprintf('%0.2d',im),'.grib'];

info = georasterinfo(era5_file);
metadata = info.Metadata;
band_t2m=find(info.Metadata.Element=='2T');
band_d2m=find(info.Metadata.Element=='2D');
band_sp=find(info.Metadata.Element=='SP');

[t2m,R] = readgeoraster(era5_file,Bands=band_t2m);
[d2m,R] = readgeoraster(era5_file,Bands=band_d2m);
[sp,R] = readgeoraster(era5_file,Bands=band_sp);

clear t2m_s d2m_s sp_s
t2m_s=zeros(numel(in_state),size(t2m,3));
d2m_s=zeros(numel(in_state),size(t2m,3));
sp_s=zeros(numel(in_state),size(t2m,3));

for ig=1:numel(in_state)
    t2m_s(ig,:)=t2m(ij(in_state(ig),2),ij(in_state(ig),1),:);
    d2m_s(ig,:)=d2m(ij(in_state(ig),2),ij(in_state(ig),1),:);
    sp_s(ig,:)=sp(ij(in_state(ig),2),ij(in_state(ig),1),:);
end

clear rh qs
[rh,qs]=rh_qs(t2m_s,d2m_s,sp_s);

rh_state=cat(2,rh_state,rh);
qs_state=cat(2,qs_state,qs);
t2m_state=cat(2,t2m_state,t2m_s);

end
toc
end

