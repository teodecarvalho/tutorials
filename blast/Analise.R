library(Biostrings)
library(tidyverse)


tabela <- read_delim(file = "resultado.txt", delim = "\t", comment = "#", col_names = FALSE) %>%
  rename(query = X1,
         subject = X2,
         identity = X3,
         alignment = X4,
         mismatches = X5,
         gaps = X6,
         query_start = X7,
         query_end = X8,
         subj_start = X9,
         subj_end = X10,
         evalue = X11,
         bit_score = X12)


genoma <- readDNAStringSet("all.fna")
target <- readDNAStringSet("target.fna")

tabela[1, ]
nomes_contigs <- names(genoma)
filtro <- str_detect(nomes_contigs, "NZ_CP017637.1")
contig <- genoma[filtro]
sub_16s <- subseq(contig, start = 1523958, end = 1525446)

### Criando uma nova função que aceita start > end
my_subseq <- function(seq, start, end){
  if(start < end){
    subsequence <- subseq(seq, start = start, end = end)
  } else {
    subsequence <- subseq(seq, start = end, end = start) %>%
      reverseComplement()
  }
  return(subsequence)
}

nomes_contigs <- names(genoma)
sequences <- list()
for(linha_i in 1:nrow(tabela)){
  linha <- tabela[linha_i, ]
  start <- linha$subj_start
  end <- linha$subj_end
  nome <- linha$subject
  filtro <- str_detect(nomes_contigs, nome)
  contig <- genoma[filtro]
  sequences[[nome]] <- my_subseq(contig, start = start, end = end)
}

writeXStringSet(unlist(DNAStringSetList(sequences)), "16S_all.fna")
