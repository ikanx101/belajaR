model_reg
data_new = data.frame(harga=seq(10,20,0.1),qty=1)
str(data_new)

data_new$qty.new = predict(model_reg,newdata = data_new)
data_new %>% 
  mutate(omset = harga * qty.new) %>%
  filter(omset == max(omset))
