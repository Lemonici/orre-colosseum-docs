using CSV, DataFramesMeta, HTTP

pkmn = ["Starmie", "Tauros", "Raikou"]
all_pkmn = CSV.read(download("https://gist.githubusercontent.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6/raw/92200bc0a673d5ce2110aaad4544ed6c4010f687/pokemon.csv"), DataFrame)

link_strings = ["[![" * i * "]](https://bulbapedia.bulbagarden.net/wiki/" * i * "_(Pok%C3%A9mon)) " for i in replace.(pkmn, " " => "_")]
println(join(link_strings))

nums = [all_pkmn[!, "#"][all_pkmn.Name .== i][1] for i in pkmn]

pic_strings = similar(pkmn)

for i in eachindex(nums)
    page = String(HTTP.get("https://archives.bulbagarden.net/wiki/File:Box_XD_" * lpad(nums[i], 3, "0") * ".png").body)
    idx = findfirst("/Box_XD", page)[1]
    pic_strings[i] = page[(idx - 50):(idx + 14)]
end

pic_ref_strings = ["[" * i[1] * "]: " * i[2] * "\n" for i in zip(replace.(pkmn, " " => "_"), pic_strings)]
println(join(pic_ref_strings))