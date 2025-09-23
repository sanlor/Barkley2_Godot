extends Resource
class_name B2_Gun_Genes

## Resource to organize gene related stuff.
# Check B2_Weapon resource

## List of genes that a gun can have.
enum GENE{PREFIX1,PREFIX2,SUFFIX,ATTACK,SPEED,ACCURACY,AFFIX,WEIGHT,POINTS,AMMO,DAM_GENERIC,DAM_BIO,DAM_CYBER,DAM_MENTAL,DAM_COSMIC,DAM_ZAUBER}

## Symbol used to identify each gene. Dominant genes are written in captial letters and ressessive genes are written in lower letters.
const GENE_SYMBOL : Dictionary[GENE,String] = {
	GENE.PREFIX1 		: "T",
	GENE.PREFIX2 		: "Y",
	GENE.SUFFIX			: "K",
	GENE.ATTACK			: "A",
	GENE.SPEED			: "S",
	GENE.ACCURACY		: "C",
	GENE.AFFIX			: "F",
	GENE.WEIGHT			: "W",
	GENE.POINTS			: "P",
	GENE.DAM_GENERIC	: "G",
	GENE.DAM_BIO		: "B",
	GENE.DAM_CYBER		: "C",
	GENE.DAM_MENTAL		: "M",
	GENE.DAM_COSMIC		: "O",
	GENE.DAM_ZAUBER		: "Z",
}

## Apply genes
static func apply_genes( wpn : B2_Weapon, gene_amount : int ) -> void:
	# Randomly assign genes to the gun, based on random chance (for now)
	var gene_pool := B2_Gun_Genes.GENE.values()
	for i in gene_amount:
		gene_pool.shuffle()
		## TODO add a way for luck to influence this.
		if randf() > 0.5:
			wpn.dominant_genes.append( gene_pool.pop_back() )
