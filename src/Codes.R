library(car)
library(Rmisc)
library(multcompView)
library(lsmeans)
library(ggplot2)
library(emmeans)
getwd()
setwd("D:\\MCA")
df = read.csv("streptonigrin_data_anova.csv")
head(df)

sum = summarySE(data = df, measurevar = "OD", groupvars = c("DOSE", "STRAIN"))
print(sum)

pd = position_dodge(.2)

ggplot(sum, aes(x= STRAIN,  y=OD,   color= DOSE)) +
  geom_errorbar(aes(ymin=OD-se,  
                    ymax=OD+se), width=.2, size=0.7, position=pd) +
    geom_point(shape=15, size=4, position=pd) 


#CREATING MODEL ON OD USING STRAIN AND DOSE 
model = lm (OD~ STRAIN + DOSE + DOSE:STRAIN, data = df)

Anova(model, type="II")
summary(model)


hist(residuals(model), col="darkgray")
plot(fitted(model), residuals(model))


ab = emmeans(model, "STRAIN")
pairs(ab)


sink("results.txt")
print(sum)
print(summary(model))
print(pairs(ab))
sink()











