% Base period 1991–2020 ALSO 1961-1990 ALSO 1981-2010
% Calculating the criterion - sensitivities etc

% Data file 

clear

data_in='C:/Users/avintzil/Code/DATA/';
US_State='TEXAS';
file_in=[data_in,US_State,'_1979_2023.mat'];

% Calendar
cal=datetime(1979,1,1,0,0,0):hours(1):datetime(2023,12,31,23,0,0);
cal_day=datetime(1979,1,1):datetime(2023,12,31);

load(file_in)
t2m_state=t2m_state-273.15;


% compute heat-index

for k=1:numel(cal)
    cal(k)
    for i=1 :size(t2m_state,1)
        hi(i,k)=heat_index_noaa(t2m_state(i,k),rh_state(i,k));
    end
end


% Compute n-day averages

n_average_day=10;

for k=n_average_day:numel(cal_day)
    clear oo
    oo=find(cal>=cal_day(k-n_average_day+1) & cal<=cal_day(k)+hours(23));
    t2m_mean(:,k)=mean(t2m_state(:,oo),2);
    qs_mean(:,k)=mean(qs_state(:,oo),2);
    hi_mean(:,k)=mean(hi(:,oo),2);
end

% Criterion
% 5 < t2m <11
% 3 < q2m < 6

clear criterion heat_measure mhi
mhi=mean(hi_mean);

n_tot=size(t2m_mean,1);

for k=1:numel(cal_day)
    clear oo
    oo=find((t2m_mean(:,k) >=5 & t2m_mean(:,k)<=11) & (qs_mean(:,k)>=3 & qs_mean(:,k)<=6));
    criterion(k)=numel(oo)/n_tot;
    clear oo
    oo=find(hi_mean(:,k) >=90);
    heat_criterion(k)=numel(oo)/n_tot;
end

% Mean annual cycle from 1991 to 2020

cals=datetime(1979,1,1):datetime(1979,12,31);
for t=1:365
    clear oo
    oo=find(month(cal_day)==month(cals(t)) & day(cal_day)==day(cals(t)) ... 
    & (year(cal_day)>=1991 & year(cal_day)<=2020));
    seas_criterion(t)=mean(criterion(oo));
    seas_heat_criterion(t)=mean(heat_criterion(oo));

end

clear oo
oo=find(cal_day>=datetime(2020,1,1) & cal_day<=datetime(2023,12,31));
figure(1)
clf
subplot(2,1,1)
plot(cal_day(oo),criterion(oo),'b','linewidth',2)
hold on
plot(cal_day(oo),heat_criterion(oo),'r','linewidth',2)