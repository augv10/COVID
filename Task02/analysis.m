
clear
file_cdc_01='D:/DATA/CDC/Provisional_COVID-19_Death_Counts_by_Week_Ending_Date_and_State_20240303.csv';
file_cdc_02='D:\DATA\CDC\NWSS_Public_SARS-CoV-2_Wastewater_Metric_Data_20240303.csv';

US_State='Texas';

[DataAsOf, StartDate, EndDate, Group, Year, Month, MMWRWeek, WeekEndingDate, State, ... 
COVID19Deaths, TotalDeaths1, PercentOfExpectedDeaths, PneumoniaDeaths, ...
PneumoniaAndCOVID19Deaths, InfluenzaDeaths, PneumoniaInfluenzaOrCOVID19Deaths, Footnote] = ...
importfile_cdc_mort(file_cdc_01);

clear oo
oo=find(State==US_State & Group=='By Week');

figure(2)
clf

subplot(2,1,1)
hold on

plot(EndDate(oo),COVID19Deaths(oo)/max(COVID19Deaths(oo)),'k','linewidth',2)
set(gca,'fontsize',13,'fontweight','bold')
xlim([datetime(2020,1,1) datetime(2024,2,29)])
title(['Normalized mortality in ',US_State],'fontsize',14)
grid

[wwtp_jurisdiction, wwtp_id, reporting_jurisdiction, sample_location, ... 
    sample_location_specify, key_plot_id, county_names, county_fips, ...
    population_served, date_start, date_end, ptc_15d, detect_prop_15d, percentile, ...
    sampling_prior, first_sample_date] = ...
    importfile_cdc_waste(file_cdc_02);

clear oo
oo=find(percentile==999);
percentile(oo)=NaN;

clear oo
%oo=find(wwtp_jurisdiction=='Maryland');
oo=find(wwtp_jurisdiction==US_State);

clear zz
zz=unique(wwtp_id(oo));


subplot(2,1,2)

hold on
grid

clear size_waste num_sites
for k=1:numel(zz)
    clear aa aa1 
    aa=find(wwtp_id(oo)==zz(k));
    aa1=unique(sample_location_specify(oo(aa))); 
    size_waste(k)=numel(aa);
    num_sites(k)=numel(unique(sample_location_specify(oo(aa))));
end

[i,k]=max(size_waste./num_sites);

%for k=1:numel(zz)
    clear aa aa1 
    aa=find(wwtp_id(oo)==zz(k));
    aa1=unique(sample_location_specify(oo(aa))); 
    size_waste(k)=numel(aa);
    for m=1:numel(aa1)
        clear ll
        ll=find( sample_location_specify(oo(aa))==aa1(m));
    aa=find(wwtp_id(oo)==zz(k));
    aa1=unique(sample_location_specify(oo(aa)));
    plot(date_end(oo(aa(ll))),percentile(oo(aa(ll)))/100,'k','linewidth',2)
    grid
    end 
    set(gca,'fontsize',13,'fontweight','bold')
    grid
    xlim([datetime(2020,1,1) datetime(2024,2,29)])
    title(['Quantile of SARS-CoV-2 in ',US_State],'fontsize',14)
    %plot(date_end(oo(aa)),detect_prop_15d(oo(aa)),'k')
%end



