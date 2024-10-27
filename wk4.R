library(sf)
library(dplyr)
library(readxl)
library(tidyr)

# Read
gender_data <- read_excel("hdr-data.xlsx", sheet = 1)
head(gender_data)
world_data <- st_read("World_Countries_(Generalized)_9029012925078512962.geojson")
head(world_data)


gender_data_2010 <- gender_data %>% filter(year == 2010) %>% select(COUNTRY, value)
gender_data_2019 <- gender_data %>% filter(year == 2019) %>% select(COUNTRY, value)
gender_data_2010 <- gender_data_2010 %>% rename(`2010` = value)
gender_data_2019 <- gender_data_2019 %>% rename(`2019` = value)

# join
GII <- left_join(gender_data_2010, gender_data_2019, by = "COUNTRY")
head(GII)

# Difference
GII_dif <- GII %>%
  mutate(inequality_diff = `2019` - `2010`)

head(GII_dif)

#Join
world_inequality <- world_data %>%
  left_join(GII_dif, by = c("COUNTRY" = "COUNTRY"))
head(world_inequality)

#plot
library(ggplot2)

ggplot(data = world_inequality) +
  geom_sf(aes(fill = inequality_diff), color = "white") +
  scale_fill_viridis_c() +  
  labs(fill = "GII Difference 2010-2019") +
  theme_minimal() +
  theme(legend.position = "bottom")  

ggsave("world_inequality_map.png", width = 10, height = 6, dpi = 300)
