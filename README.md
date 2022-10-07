# Cyclistic-Case-Study

This project is the capstone project of the Google Data Analytics training on the Coursera platform.

Ask, prepare, process, analyze, share and act are completed by following the steps.

# Dataset

You can access the dataset I used from the link below. This dataset consists of 12 separate zip files. Datasets from 202101 to 202112 were used.
https://divvy-tripdata.s3.amazonaws.com/index.html

# About the company

In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime. Our managers do their best for the growth of the company. The biggest step forward is to convert casual riders into annual members.

# Goals & Steps

Our manager Moreno asked me to do part of this analysis. The question I have to answer is to determine the difference between casual riders and annual members and how to convert casual riders to annual members. In order to do this analysis, I needed verified and reliable data. Our administrator has turned off this data requirement. He shared with me the total 12-month data of the Cyclistic company for 2021. These data did not fully comply with ROCCC principles. There were irregularities, outliers, and noise in the data. It was my duty to ensure that this data is reliable and verified. I immediately started pre-cleaning the data. You can access this cleaning from the link below. 
https://github.com/mrtcrpr/Cyclistic-Case-Studies/blob/main/pre_cleaning.sql

After pre-cleaning the data, I moved on to the actual cleaning. Too much noise and null values were present in the data. These values could undermine the accuracy of the data. After doing this cleanup I got to work on the question given to me. I had to find the difference between ordinary drivers and annual members and should make ordinary drivers annual members. I immediately started to work and started to get one step closer to the answer of the question by going to the analysis stage. You can access my analysis from the link below. 
https://github.com/mrtcrpr/Cyclistic-Case-Studies/blob/main/cleaning_analysis.sql

I have completed the cleaning and analysis phase. In the process, I had already formed an insight. In order for these insights to be more descriptive and understandable, the data needed to be visualized. I also used Tableau Desktop for this visualization process. I visualized the data in a clear and understandable way as I went. I also made what I wanted to tell more understandable by creating a storytelling in this application. You can access the dashboards and storytelling from the links below. 

Dashboards: https://public.tableau.com/app/profile/mrtcrpr/viz/CyclisticCaseStudy-Dashboards/Dashboard1 

Storytelling: https://public.tableau.com/app/profile/mrtcrpr/viz/CyclisticCaseStudy-Storytelling/Story1

Based on my analysis and insights, I have reached the following information. Both types mostly preferred classic bikes. I thought these bikes would be used mostly for hobby purposes. In addition, when we look at the hourly and daily visualizations in the later stages of the analysis, the annual members mostly used the bikes during commute and exit hours. On annual drives, we encountered data that was general and almost non-movement all week long. This situation was different for casual drivers. We have seen casual drivers actively using their bikes throughout the weekend, starting from the rush hour on Fridays. In the later parts of the analysis, the seasons greeted us. Casual drivers hardly used them, especially in the winter and spring seasons compared to other seasons of the year. When the summer and autumn seasons came, casual riders were using bicycles more actively than annual riders. This confirmed our insight. Casual drivers used their bikes mostly for hobby and sports purposes.

# Summary

Our analysis and insights were complete. The final question we had to answer was how to convert casual drivers into annual drivers. Based on my analysis, I started to think about this issue. As can be clearly seen, casual drivers used bicycles mostly for hobby and sports purposes. We knew that casual riders use bikes especially on weekends. When the summer and autumn seasons came, there was a significant increase in the number of uses. Based on this insight, I asked my manager, Moreno, to offer discounts to ordinary drivers, especially on weekends. The main purpose here was not to convert casual drivers to annual members with the weekend discount. This discount was just a nice preparation for the summer and autumn seasons. I showed my manager Moreno two roadmaps. The first was the introduction of a membership system only for the summer and autumn seasons. The second was the introduction of discounts to annual memberships towards the end of the spring season. My manager Moreno talked about this situation with his managers, showing my analysis, insights and visualizations. They accepted the first option I suggested. Only for the summer and autumn seasons, casual drivers were given a 50% discount. Thus, I completed this task given to me by cleaning, analyzing, visualizing and generating insights from data.
