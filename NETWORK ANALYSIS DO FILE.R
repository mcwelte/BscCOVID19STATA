#Computation for final graph 
dataformatrix <- equ.jointYQ2 [ c(2:17) , c(2:17) ]
jointmatrix1 <- as.matrix(sapply(dataformatrix, as.numeric))
jointmatrix1[is.na(jointmatrix1)] <- 0



#final graph
print(dataformatrix)
library(qgraph)
Finalgraphforpaper <- qgraph(jointmatrix1,layout = "spring",  theme = "Borkulo", labels = TRUE, threshold = 0.5,minimum =0.5, edge.labels = FALSE, esize= 3, nodeNames = c("Diabetes Prevelance","Cardiovascular Deathrates","Resperatory Deathrates","Obesity Prevelance","Smoking Prevelance","Alcohol Consumption","Population Density","Old-Age Dependancy",
                                                                                                                                                            "Incidence of Tuberculosis","Healthcare-Quality Index","Count of Hospital beds","Multilinear Poverty","% of Population National Poverty","Incidence of Air Pollution","Educational Attainment",
                                                                                                                                                "Mean Stringecy of Response"), legend.cex= 0.35, negCol= c("#00000000","white"), curve = jointmatrix1, repulsion =0.5, colFactor = 1,filetype='png',height=6,width=5) 


#computation for robutnss jointness matrix 
dataformatrix <- equ.jointYQ3 [ c(2:16) , c(2:16) ]
jointmatrix2 <- as.matrix(sapply(dataformatrix, as.numeric))
jointmatrix2[is.na(jointmatrix2)] <- 0

