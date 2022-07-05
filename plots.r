png('./img/activityPerDay.png')
qplot(stepsByDay,
      data =stepsByDay,
      na.rm = T,
      binwidh = 500,
      xlab = 'total Steps per day',
      ylab = 'Frequency with binwidth 500 ')
dev.off()

png('./img/averageStepsAcrossDays.png')
qplot(interval,
      average,
      data = interval_average,
      geom  = 'line',
      xlab = '5 min interval along the day',
      ylab = 'Average steps taken across all days'
)
dev.off()

png('./img/ActivityPerDayCleaned.png')
qplot(stepsPerDay, data = stepsByDay_binded,
      na.rm = T,
      binwidth = 500,
      xlab = 'total Steps per day',
      ylab = 'Frequency with binwidth 500 ')
dev.off()

png('./img/panelPlot.png')
qplot(interval,average,data=meansteps,geom="line",facets=weekend~.,xlab="5-minute interval",ylab="average number of steps",main="Average steps pattern between Weekday and Weekend")
dev.off()