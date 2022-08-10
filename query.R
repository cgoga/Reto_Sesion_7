library(gitcreds)
library(dplyr)
library(pool)
library(DBI)
library(ggplot2)

#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
# gitcreds_set()
#gitcreds_get()

conn <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")

dbListTables(conn)
dbListFields(conn,"CountryLanguage")

#Porcentaje de personas que hablan español en todos los países
res<- dbSendQuery(conn, 
                  "select CountryCode, Percentage,IsOfficial 
                  from CountryLanguage 
                  where Language='Spanish';")
datos<- dbFetch(res)
str(datos)

g<- ggplot (datos, aes(x=CountryCode,y=Percentage,fill=IsOfficial )) +
  geom_bar(stat = "Identity")+
  geom_hline(yintercept = 0, size = 1, colour="#333333") +
  scale_y_continuous(labels = function(x) paste0(x, "%"))+
  bbc_style() +
  labs(title="%Población de habla Hispana por País")+
  coord_flip() +
  theme(panel.grid.major.x = element_line(color="#cbcbcb"), 
        panel.grid.major.y=element_blank())+
  scale_fill_hue(labels =c("No-Oficial", "Oficial"))
g

dbClearResult(res)

#Paquete bbplot
install.packages('devtools')
devtools::install_github('bbc/bbplot')
library(bbplot)

dbDisconnect(conn)
rs <- dbSendQuery(conn, "SELECT * FROM City LIMIT 5;")