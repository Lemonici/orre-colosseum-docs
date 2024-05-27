using CSV, DataFramesMeta

# Replace with current vr
dat = CSV.read("vr_data/vr4.csv", DataFrame, header=false)

# Pokemon CSV courtesy of armgilles
# all_pkmn = CSV.read(download("https://gist.githubusercontent.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6/raw/92200bc0a673d5ce2110aaad4544ed6c4010f687/pokemon.csv"), DataFrame)
all_pkmn = CSV.read("vr_data/pokemon.csv", DataFrame)

N = nrow(dat)
M = ncol(dat)

table = ""
refs = ""

for j in 1:N
    table = table * "|" * dat[j, 1] * "|"

    pkmn = [values(dat[j, 2:M])...]
    pkmn = pkmn[.!ismissing.(pkmn)]

    link_strings = ["[![" * i[1] * "]](https://bulbapedia.bulbagarden.net/wiki/" * i[2] * "_(Pok%C3%A9mon)) " for i in zip(pkmn, replace.(pkmn, " " => "_"))]
    table = table * join(link_strings) * "|\n"

    nums = [all_pkmn[!, "#"][all_pkmn.Name .== i][1] for i in pkmn]
    pic_strings = ["{% link assets/images/XD_box_sprites/Box_XD_" * lpad(i, 3, "0") * ".png %}" for i in nums]
    pic_ref_strings = ["[" * i[1] * "]: " * i[2] * "\n" for i in zip(pkmn, pic_strings)]
    refs = refs * join(pic_ref_strings)
end


println(table)

println(refs)
