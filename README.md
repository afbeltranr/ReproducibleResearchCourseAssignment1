---
title: "Activity Monitoring data Reproducible Report"
author: "Andres Beltran"
date: "5/12/2022"
output: rmdformats::downcute
---



# Code for reading

# 1. Code for reading in the dataset and/or processing the data


First, we load the data into an R object called `activity`

```{r}
activity <- read.csv('activity.csv')
```

Then, we can change the format of the date using the function `ymd` from the package `lubridate`

```{r}
library(lubridate)
activity$date <- ymd(activity$date)
```

Then we can discriminate between weekdays and weekends, as follows:

* First, we assign the value `weekend` to activities that are recorded in a `saturday` or `sunday`, and then, using conditioning via the function `ifelse`, we assign the value `weekday` to every other day of the week:

```{r}
activity$weekend <- as.factor(
  ifelse(
          weekdays(activity$date) == 'Saturday' |    weekdays(activity$date) == 'Sunday',
          'weekend',
          'weekday'
  )
)
```

within the new column `weekend` we have a new factor that discriminates wether or not the measurement took place in a weekend. 

Also it can be useful to find which day of the week corresponds to each measurement, using the function `weekdays` we used before, we can save that information in a new columng called `dayofweek`.

```{r}
activity$dayoftheweek <- weekdays(activity$date)
```

#2. Histogram of the total number of steps taken each day

Now that we have a way to classify data, it is possible to display it in a way we can examine it. For instance a histogram can be printed using the function `qplot()` from the package `ggplot2`.

```{r}
library(dplyr)
library(ggplot2)
stepsByDay <- activity %>% group_by(date) %>% summarize(stepsByDay = sum(steps,na.rm=T))
qplot(stepsByDay,
      data =stepsByDay,
      na.rm = T,
      binwidh = 500,
      xlab = 'total Steps per day',
      ylab = 'Frequency with binwidth 500 ')
```
![](https://github.com/afbeltranr/ReproducibleResearchCourseAssignment1/blob/main/img/activityPerDay.png)

#3. Mean and median number of steps taken each day

Now we can use the data to calculate dome descriptive measures of the amount of steps taken per day such as the `mean` and the `median`

```{r}
meanstepsperday <- stepsByDay %>% summarise(average = mean(stepsByDay, na.rm = T),
                                            median = median(stepsByDay, na.rm = T))
meanstepsperday
```

#4. What is the average daily activity pattern?


We can use the `interval` variable to track how activity changes, at different times of the day. That way we can evaluate in average how the individual's activity is along the day, and if they are more active at mornings, afternoons or evenings.

```{r}
interval_average <- activity %>% group_by(interval) %>% summarise(average = mean(steps, na.rm = T))
```

Once we have saved the average activity in each interval of time, we can examine these numbers using a histogram:

```{r}
qplot(interval,
      average,
      data = interval_average,
      geom  = 'line',
      xlab = '5 min interval along the day',
      ylab = 'Average steps taken across all days'
      )
```

![](https://github.com/afbeltranr/ReproducibleResearchCourseAssignment1/blob/main/img/averageStepsAcrossDays.png)

# 5. The 5-minute interval that, on average, contains the maximum number of steps

Once we have calculated the average steps across all the days in the data set, we can find which interval has the maximum average number of steps:

```{r}
interval_average[which.max(interval_average$average),]
```
The interval in time that shows the higher average of steps across all days is #835. the higher average number of steps across all days is `206` steps.

# 6. Code to describe and show a strategy for imputing missing data


First, we create a `data.frame` with the measurements that are not missing values:
```{r}
activity_no_NA <- activity[which(!is.na(activity$steps)),]
```

Then we can convert the average number of steps for each interval to an integer:

```{r}
noNAIntervalmean <- activity_no_NA %>% group_by(interval) %>% summarise(average = mean(steps))
noNAIntervalmean$average <- as.integer(noNAIntervalmean$average)
```

now we extract the intervals that have NA:

```{r}
activity_na <- activity[which(is.na(activity$steps)),]

```

Now we can fill the blank spaces with the average values based on each interval:

```{r}
activity_na$steps <- ifelse(activity_na$interval == noNAIntervalmean$interval, noNAIntervalmean$average)
```

Now we can bind the data sets:

```{r}
activity_binded <- rbind(activity_no_NA, activity_na)
```

by using the previous chunks of code we successfully replaced the `NA`s present in the data table by the average count of steps for each interval of time. We can plot the result as follows:


```{r}
stepsByDay_binded <- activity_binded %>% group_by(date) %>% summarise(stepsPerDay = sum(steps))

qplot(stepsPerDay, data = stepsByDay_binded,
      na.rm = T,
      binwidth = 500,
      xlab = 'total Steps per day',
      ylab = 'Frequency with binwidth 500 ')
```

!()[https://github.com/afbeltranr/ReproducibleResearchCourseAssignment1/blob/main/img/ActivityPerDayCleaned.png]


We can also assess how replacing NAs by numbers (increasing the sample size) affects the values of the mean and the median:

```{r}
TotalStepsPerDayBind <- activity_binded %>% group_by(date) %>% summarise(stepsperday = sum(steps))
mean_median <- TotalStepsPerDayBind %>% summarise(average = mean(stepsperday), median = median(stepsperday))
mean_median
```



# 7. Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends

```{r}
meansteps <- activity_binded %>% group_by(interval, weekend) %>% summarise(average = mean(steps))

qplot(interval,average,data=meansteps,geom="line",facets=weekend~.,xlab="5-minute interval",ylab="average number of steps",main="Average steps pattern between Weekday and Weekend")
```

![](https://github.com/afbeltranr/ReproducibleResearchCourseAssignment1/blob/main/img/panelPlot.png)

We can see that at weekends, this person takes a longer time to begin their walk. Also the number of steps are better distributed along the time interval axis. 
