FixtureBuilder.configure do |fbuilder|
  fbuilder.files_to_check += Dir["spec/factories/**/*.rb", "spec/support/fixture_builder.rb"]

  fbuilder.factory do
    # Users
    fbuilder.name(:standard_user, FactoryGirl.create(:user))

    # Neighborhoods
    Loader::Neighborhood.from_shapefile(
      Rails.root.join("lib/data/shapefiles/neighborhoods/region.shp").to_s)

    # Worlds
    @nyc = Loader::World.generate({
      name: "NYC",
      region_name_key: "BoroName",
      inverse_scale: 3000,
      tolerance: 200
    }).save!

    # Zip Code
    zip_code_row = [
     1, "1", nil, nil, nil, 0, nil, nil, "1",
     [nil, "40.74916512200008", "-73.86942583199993", nil, false,
      {"rings"=>
        [[[-73.86942583199993, 40.74916512200008],
          [-73.86955990199993, 40.74914555000004],
          [-73.87021396699993, 40.74908723300007],
          [-73.8703564729999, 40.74907447700008],
          [-73.87040365999991, 40.74907022500008],
          [-73.87052257199991, 40.74905959400007],
          [-73.87097571099991, 40.74901312900005],
          [-73.8713583999999, 40.74896508300009],
          [-73.87184221199993, 40.748913842000036],
          [-73.87237382099994, 40.74885982400008],
          [-73.8727748309999, 40.74882122900004],
          [-73.8733043549999, 40.74876640100007],
          [-73.87370224099993, 40.748725593000074],
          [-73.87398419099992, 40.74869394400008],
          [-73.87463071399992, 40.74862220400007],
          [-73.87542336899992, 40.748535761000085],
          [-73.87555805099993, 40.748522397000045],
          [-73.87610964699991, 40.74846211000005],
          [-73.87625295299995, 40.74844664200003],
          [-73.87648078599995, 40.748424672000056],
          [-73.8769258399999, 40.74837725600008],
          [-73.8774173779999, 40.74832764200005],
          [-73.87835139899994, 40.74823057200007],
          [-73.87845535799994, 40.748219008000035],
          [-73.87927904799994, 40.74813236400007],
          [-73.87984020199991, 40.74806999800006],
          [-73.88000021199991, 40.748054548000084],
          [-73.88011938699992, 40.748042319000035],
          [-73.88020773999995, 40.748033252000084],
          [-73.8803128799999, 40.74802222000005],
          [-73.88103618699995, 40.747946323000065],
          [-73.88113873099991, 40.747935562000066],
          [-73.88125193399992, 40.74792375800007],
          [-73.88197241499995, 40.747848625000074],
          [-73.8820723799999, 40.747838201000036],
                [-73.88218607999994, 40.74782630000004],
      [-73.88246241099995, 40.74779737700004],
      [-73.88257002599994, 40.747786113000075],
      [-73.88267312199991, 40.74777571000004],
      [-73.88291471499991, 40.74775132900004],
      [-73.8830004379999, 40.747742678000066],
      [-73.88310622199992, 40.747730914000044],
      [-73.88385381099994, 40.74764777300004],
      [-73.88393704899994, 40.74763851600005],
      [-73.88403464599992, 40.74762838800007],
      [-73.88474369999994, 40.74755480600004],
      [-73.88485663999995, 40.747543085000075],
      [-73.88495637199992, 40.74753291400009],
      [-73.88569503299993, 40.74745757900007],
      [-73.88578866199992, 40.747448030000044],
      [-73.88588197099995, 40.74743816000006],
      [-73.88661202299994, 40.74736093100006],
      [-73.88671782099993, 40.74734973900007],
      [-73.88680843299994, 40.747340327000074],
      [-73.88755405599994, 40.74726287000004],
      [-73.88764753899994, 40.747253158000035],
      [-73.88769960099995, 40.74724710400005],
      [-73.88778451499991, 40.74723722900006],
      [-73.88787705099992, 40.747227432000045],
      [-73.88858298499991, 40.74715270200005],
      [-73.8886789199999, 40.74714254600008],
      [-73.88876946699992, 40.74713281000004],
      [-73.88902443599994, 40.74710539200004],
      [-73.88957253399991, 40.74704732500004],
      [-73.8905025549999, 40.74695021500008],
      [-73.89064206899991, 40.746935618000066],
      [-73.89143256599993, 40.746852911000076],
      [-73.8915726859999, 40.74683838100009],
      [-73.89175171699992, 40.74681981500004],
      [-73.89220658799991, 40.74677293000008],
      [-73.89232216499994, 40.74676101600005],
      [-73.89253751299992, 40.746738538000045],
      [-73.89291555799991, 40.74669907800006],
      [-73.89358944299994, 40.74662873300008],
      [-73.89369593299995, 40.74661764600006],
      [-73.89436939299992, 40.746547529000054],
      [-73.89461078599993, 40.746522396000046],
      [-73.89471788199995, 40.74651124400009],
      [-73.89480946799995, 40.74650170800004],
      [-73.8948658729999, 40.74649571100008],
      [-73.89488500099992, 40.746493678000036],
      [-73.89494086999991, 40.74648773700005],
      [-73.89499422999995, 40.74648206400008],
      [-73.89502066599994, 40.746479253000075],
      [-73.89507269899991, 40.746473721000086],
            [-73.89510375299994, 40.74653016700006],
      [-73.89513106899994, 40.74657981100006],
      [-73.89528392799991, 40.74685763700006],
      [-73.8953284179999, 40.74693849500005],
      [-73.89554730999993, 40.74742132300008],
      [-73.89556469899992, 40.74745967900009],
      [-73.89566101199995, 40.74764901600008],
      [-73.89583618699993, 40.74795420000004],
      [-73.89609895599995, 40.74837296700008],
      [-73.89612750999993, 40.748419037000076],
      [-73.8961512599999, 40.748457356000074],
      [-73.89618864599993, 40.74851767600006],
      [-73.89613428899992, 40.74852352800008],
      [-73.8961118599999, 40.74852594300006],
      [-73.89605839599994, 40.74853170000006],
      [-73.89600218099991, 40.74853775200006],
      [-73.89596899299994, 40.748541325000076],
      [-73.89584080899994, 40.74855512600004],
      [-73.89525369499995, 40.74831486000005],
      [-73.89529403899991, 40.74843145700004],
      [-73.89531997799992, 40.748506424000084],
      [-73.89535262299995, 40.74860076900006],
      [-73.89550225999994, 40.748840761000054],
      [-73.89587599299995, 40.74944015500006],
      [-73.89610003199994, 40.74977367200006],
      [-73.89618582899993, 40.74990139300007],
      [-73.89654167899994, 40.75055024900007],
      [-73.89579995399993, 40.750627972000075],
      [-73.89584983599991, 40.75069971000005],
      [-73.8961773019999, 40.752467763000084],
      [-73.89619341999992, 40.75256796500008],
      [-73.89623743299995, 40.752819539000086],
      [-73.89626560799991, 40.75298058800007],
      [-73.8964464419999, 40.75397914600006],
      [-73.8965235739999, 40.754397048000044],
      [-73.8964461779999, 40.754405004000034],
      [-73.8960468599999, 40.75444605000007],
      [-73.89570034899992, 40.75448166800004],
      [-73.89559097499995, 40.75449291000007],
      [-73.89466232699993, 40.75459170600004],
      [-73.8937357229999, 40.75468902800009],
      [-73.89280469899995, 40.754786193000086],
      [-73.89188191999995, 40.75488159200006],
      [-73.8909489479999, 40.75498201500005],
      [-73.89001466099995, 40.75507908600008],
      [-73.88908942299992, 40.75517864500006],
      [-73.88901097599995, 40.755184660000054],
      [-73.88815798999991, 40.75527409300008],
      [-73.88722909499995, 40.75537158000009],
      [-73.88629940899995, 40.75546874400004],
            [-73.88536853599993, 40.75556522200009],
      [-73.88444034399993, 40.755665727000064],
      [-73.88350818299995, 40.755763597000055],
      [-73.88258038599992, 40.75586184900004],
      [-73.88164938499995, 40.75595986900004],
      [-73.88072054199995, 40.756057368000086],
      [-73.8799856569999, 40.75613419500007],
      [-73.87979035599994, 40.75615505500008],
      [-73.87886178299993, 40.75624974500005],
      [-73.87793155999992, 40.756347289000075],
      [-73.87699915299993, 40.75644723800008],
      [-73.87606912599995, 40.75654450400009],
      [-73.87514000199991, 40.75664209000007],
      [-73.87420928699993, 40.756739835000076],
      [-73.8736584749999, 40.75681176000006],
      [-73.87311180499995, 40.75685916000003],
      [-73.87297108999991, 40.75687136100004],
      [-73.87221981899995, 40.75695150100006],
      [-73.87217833999995, 40.75673912900004],
      [-73.8718870809999, 40.755121828000085],
      [-73.87168118299991, 40.75399542700006],
      [-73.87168609899993, 40.753969114000085],
      [-73.87172673099991, 40.75393940500004],
      [-73.87174981899994, 40.75393381100008],
      [-73.87186300299993, 40.75391227300008],
      [-73.8719007979999, 40.75390523800007],
      [-73.87194007799991, 40.753897762000065],
      [-73.8720717249999, 40.75387025900005],
      [-73.8720297449999, 40.75378516600006],
      [-73.8717991609999, 40.75334438100003],
      [-73.87178725299992, 40.75332186600008],
      [-73.87097032999992, 40.751791499000035],
      [-73.8708455929999, 40.75155690100007],
      [-73.86983872499991, 40.74987463400004],
      [-73.8698185479999, 40.74984099900007],
      [-73.8697428129999, 40.749714802000085],
      [-73.86968676099991, 40.749620631000084],
      [-73.86963570099994, 40.74953564500004],
      [-73.86955861799993, 40.74939955700006],
      [-73.86947435699994, 40.74925079600007],
      [-73.86942583199993, 40.74916512200008]]]}],
   "11372", "Jackson Heights", "NY", "Queens", "36", "081", "0",
   "20624.6923165409825742244720458984375", "20163283.874320156872272491455078125"]

    @zipCode = Loader::ZipCodeMap.build_from_row(zip_code_row).save!
  end
end
