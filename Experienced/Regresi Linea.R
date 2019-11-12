rm(list=ls())

#ambil data
data = read.csv('https://raw.githubusercontent.com/rc-dbe/bigdatacertification/master/dataset/Salary_Data.csv')

#bebersih nama variabel
data = janitor::clean_names(data)

#bikin model regresi
model=lm(salary~years_experience,data=data)

#hasilnya
model
summary(model)

model$coefficients