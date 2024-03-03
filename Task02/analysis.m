
file_cdc_01='D:/DATA/CDC/Provisional_COVID-19_Death_Counts_by_Week_Ending_Date_and_State_20240303.csv';
file_cdc_02='D:\DATA\CDC\NWSS_Public_SARS-CoV-2_Wastewater_Metric_Data_20240303.csv';

[DataAsOf, StartDate, EndDate, Group, Year, Month, MMWRWeek, WeekEndingDate, State, ... 
COVID19Deaths, TotalDeaths1, PercentOfExpectedDeaths, PneumoniaDeaths, ...
PneumoniaAndCOVID19Deaths, InfluenzaDeaths, PneumoniaInfluenzaOrCOVID19Deaths, Footnote] = ...
importfile_cdc_mort(file_cdc_01);

clear oo
oo=find(State=='Maryland' & Group=='By Week');



clear oo
oo=find(State=='Alaska' & Group=='By Week');

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
oo=find(wwtp_jurisdiction=='Nebraska');

clear zz
zz=unique(wwtp_id(oo));

figure(1)
clf
hold on

for k=1:numel(zz)
    clear aa
    aa=find(wwtp_id(oo)==zz(k));
    plot(date_end(oo(aa)),percentile(oo(aa)),'k')
end



