clear all

** Please import the file "RA_21_22.csv"
**import delimited "/Users/giacomoricciardi/Desktop/Research/University of Chicago/Research Professional/Data Task/RA_21_22.csv"

******************************************* QUESTION 1 *******************************************

*** DATASET: Survey of Consumer Finances, 1989-2016 (year, survey weight, demographic characteristics, income, housing assets, total assets, housing debt, and total debt).

** I scaled both total and housing wealth to the maximum weight. By doing this, we did not lose in terms of interpretation of results but the values were scaled
** so to take into account the survey weights. Wealth is defined as (assets - debt).
 
egen max_weight = max(weight)
gen total_wealth = (asset_total - debt_total) * (weight / max_weight)
gen housing_wealth = ( asset_housing- debt_housing) * ( weight /  max_weight)
drop max_weight

** Median total wealth computed by race
sort year race
egen median_total_wealth_race = median(total_wealth), by(year race)

separate  median_total_wealth_race, by(race)

twoway (connected median_total_wealth_race1 year) (connected median_total_wealth_race2 year) (connected median_total_wealth_race3 year) (connected median_total_wealth_race4 year), ytitle("Median Total Wealth ($)") legend(order(1 "Hispanic" 2 "Black" 3 "Other" 4 "White")) ///
xlabel(1989(3)2016) ylabel(, format(%-12.0fc)) xtitle("")

drop  median_total_wealth_race1-median_total_wealth_race4

** Median total wealth computed by education
sort year education
egen median_total_wealth_edu = median(total_wealth), by(year education)

separate  median_total_wealth_edu, by(education)

twoway (connected median_total_wealth_edu1 year) (connected median_total_wealth_edu2 year) (connected median_total_wealth_edu3 year), ytitle("Median Total Wealth ($)") legend(order(1 "College Degree" 2 "No College" 3 "Some College")) xlabel(1989(3)2016) ylabel(, format(%-12.0fc)) xtitle("")

drop  median_total_wealth_edu1-median_total_wealth_edu3

** Focus only on Black and White groups

sort year race
egen median_housing_wealth_race = median(housing_wealth), by(year race)

separate  median_housing_wealth_race, by(race)

twoway (connected median_housing_wealth_race2 year) (connected median_housing_wealth_race4 year), ytitle("Median Housing Wealth ($)") legend(order(1 "Black" 2 "White")) xlabel(1989(3)2016) ylabel(, format(%-12.0fc)) xtitle("")

drop  median_housing_wealth_race1-median_housing_wealth_race4

** Subsetting to homeowners (assets_housing > 0) and older than or equal to 25 years old to solve the median housing / total wealth being = 0 for Black families.

** Housing Wealth Analysis
sort year race
egen median_housing_wealth_race_25 = median(housing_wealth) if age >= 25 & (asset_housing > 0), by(year race) 

separate  median_housing_wealth_race_25, by(race)
twoway (connected median_housing_wealth_race_252 year) (connected median_housing_wealth_race_254 year), ytitle("Median Housing Wealth ($)") ///
legend(order(1 "Black" 2 "White")) xlabel(1989(3)2016) ylabel(, format(%-12.0fc)) xtitle("") /// 
drop  median_housing_wealth_race_251-median_housing_wealth_race_254

table year race, c(m  median_housing_wealth_race_25)

** Total Wealth Analysis
sort year race
egen median_total_wealth_race_25 = median(total_wealth) if age >= 25 & (asset_housing > 0), by(year race) 

separate  median_total_wealth_race_25, by(race)
twoway (connected median_total_wealth_race_252 year) (connected median_total_wealth_race_254 year), ytitle("Median Housing Wealth ($)") legend(order(1 "Black" 2 "White")) xlabel(1989(3)2016) ylabel(, format(%-12.0fc)) xtitle("")
drop  median_total_wealth_race_251-median_total_wealth_race_254

table year race, c(m  median_total_wealth_race_25)

