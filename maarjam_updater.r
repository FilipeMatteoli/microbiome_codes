library("gdata")
library("Biostrings")
#read taxonomy files downloaded from maarjaam
paraglom <- read.xls("/media/FULL_PATH_HERE/export_biogeo_Paraglomeromycetes.xls", sheet = 1, fileEncoding="latin1", stringsAsFactors=FALSE)
View(paraglom)
archaeo <- read.xls("/media/FULL_PATH_HERE/export_biogeo_Archaeosporomycetes.xls", sheet = 1, fileEncoding="latin1", stringsAsFactors=FALSE)
glomero <- read.xls("/media/FULL_PATH_HERE/export_biogeo_glomeromycetes.xls", sheet = 1, fileEncoding="latin1", stringsAsFactors=FALSE)
all <- rbind(paraglom,archaeo,glomero)
dim(all)
all[duplicated(all$GenBank.accession.number), ][,2]
all <- all[!duplicated(all$GenBank.accession.number), ]
dim(all)
all <- all[all$GenBank.accession.number != "YYY00000", ]
dim(all)
all.ordered <- all[order(as.character(all[,"GenBank.accession.number"])),]
dim(all.ordered)
head(all.ordered)
all.ordered_taxo <- data.frame()
for (i in 1:nrow(all.ordered)){
if (all.ordered$VTX[i] != ""){
all.ordered_taxo[i, 1] <- all.ordered[i, "GenBank.accession.number"]
all.ordered_taxo[i, 2] <- paste0("Fungi;Glomeromycota;",
all.ordered[i, "Fungal.class"],
";",
all.ordered[i, "Fungal.order"],
";",
all.ordered[i, "Fungal.family"],
";",
all.ordered[i, "Fungal.genus"],
"_",
all.ordered[i, "Fungal.species"],
"_",
all.ordered[i, "VTX"]
)
} else {
all.ordered_taxo[i, 1] <- all.ordered[i, "GenBank.accession.number"]
all.ordered_taxo[i, 2] <- paste0("Fungi;Glomeromycota;",
all.ordered[i, "Fungal.class"],
";",
all.ordered[i, "Fungal.order"],
";",
all.ordered[i, "Fungal.family"],
";",
all.ordered[i, "Fungal.genus"],
"_",
all.ordered[i, "Fungal.species"]
)
}
}
dim(all.ordered_taxo)
write.table(all.ordered_taxo, "/media/FULL_PATH_HERE/maarjAM_id_to_taxonomy.txt", sep = "\t",
row.names = FALSE, col.names = FALSE, quote = FALSE)

#read fasta files from downloaded from maarjam
paraglom.seq <- readBStringSet("/media/FULL_PATH_HERE/paraglomeromycetes_seq.txt","fasta")
names(paraglom.seq) <- gsub("gb\\|", "", names(paraglom.seq))
archaeo.seq <- readBStringSet("/media/FULL_PATH_HERE/archaeosporomycetes_seq.txt", "fasta")
names(archaeo.seq) <- gsub("gb\\|", "", names(archaeo.seq))
glomerom.seq <- readBStringSet("/media/FULL_PATH_HERE/glomeromycetes_seq.txt", "fasta")
names(glomerom.seq) <- gsub("gb\\|", "", names(glomerom.seq))

#join sequences from all files into one
all.seq <- append(paraglom.seq, c(archaeo.seq,glomerom.seq), after=length(paraglom.seq))
all.seq <- all.seq[names(all.seq) != "YYY00000"]
all.ordered.seq <- all.seq[order(as.character((names(all.seq))))]
writeXStringSet(all.ordered.seq, "/FULL_PATH_HERE/maarjAM.fasta", format="fasta")


sed -i 's/[a-z]/\U&/g' maarjAM.fasta #fix lowercase in seqs
