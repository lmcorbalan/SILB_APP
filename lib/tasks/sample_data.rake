#encoding: utf-8

require 'csv'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # make_users
    # make_countries_ragions_cities
    # categories = categories_h
    # make_categories(categories)
    make_brands
    make_products
  end
end

def make_users
  admin = User.create!(name:     "admin",
                       email:    "admin@silb.com",
                       password: "admin123",
                       password_confirmation: "admin123")
  admin.toggle!(:admin)
  admin.activate!
  10.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@silb.org"
    password  = "foobar"
    user = User.create!(name:     name,
                        email:    email,
                        password: password,
                        password_confirmation: password)
    user.activate!
  end
end

def make_countries_ragions_cities
  CSV.foreach("#{Rails.root}/public/seed_data/worldSeed.csv", {
    :headers => true, :header_converters => :symbol
  }) do |row|
    country = Country.find_by_name(row[:country]) || Country.create(name:row[:country])
    region = country.regions.find_by_name(row[:region]) || country.regions.build(name:row[:region])
    city = region.cities.find_by_name(row[:city]) || region.cities.build(name:row[:city])
    region.save!
  end
end

def make_categories(categries, parent = nil)
  categries.each { |c, sub_c|
    cat = Category.create!(:name => c.dup, :parent_id => !parent.nil? ? parent.id : nil )
    make_categories(sub_c, cat) if !sub_c.empty?
  }
end

def make_brands
  brands = {
    "Bd"            => "#{Rails.root}/public/seed_data/brands_images/bd.png",
    "Biocientifica" => "#{Rails.root}/public/seed_data/brands_images/biocientifica.png",
    "cobas"         => "#{Rails.root}/public/seed_data/brands_images/cobas.png",
    "Diestro"       => "#{Rails.root}/public/seed_data/brands_images/diestro.png",
    "Oxoid"         => "#{Rails.root}/public/seed_data/brands_images/oxoid.png",
    "Remel"         => "#{Rails.root}/public/seed_data/brands_images/remel.png",
    "Roche"         => "#{Rails.root}/public/seed_data/brands_images/roche.png",
    "Sysmex"        => "#{Rails.root}/public/seed_data/brands_images/sysmex.png",
    "Tecnon"        => "#{Rails.root}/public/seed_data/brands_images/tecnon.png",
  }

  brands.each { |name, picture_path|
    brand = Brand.create!(name: name.dup)
    brand.pictures.build( image: File.open(picture_path) )
    brand.save!
  }
end

def make_products
  require 'populator'
  categories_ids = Category.pluck(:id)
  brands_ids     = Brand.pluck(:id)

  taken_codes = {}
  taken_names = {}

  Product.populate 50 do |product|
    code = Populator.words(1) until !taken_codes[code] && !code.nil?
    taken_codes[code] = 1
    product.code = code
    name = Populator.words(1..5) until !taken_names[name] && !name.nil?
    taken_names[name] = 1
    product.name = name
    product.description = Populator.sentences(2..10)
    product.category_id = categories_ids
    product.brand_id = brands_ids
    product.price_cents = [499, 1995, 10000, 25000, 1000, 50, 65550]
    product.current_stock = [10, 20, 30, 40, 50, 100, 200]
    product.minimum_stock = 5
    product.highlight_stock_from = 8
    product.state = 'active'
    product.created_at = Time.now
  end

  image = File.open("#{Rails.root}/app/assets/images/rails.png")

  Product.all.each { |product|
    product.pictures.build( image: image )
    product.save!
  }
end

def categories_h
  return {
    "Equipamiento" =>
    {
      "Agitadores" => {},
      "Balanzas" => {},
      "Baños Termostáticos" => {
        "Sin Agitación" =>{},
        "Con Agitación" =>{}
      },
      "Centrífugas " =>{
        "Macro Centrífugas de Mesa" =>{},
        "Micro Centrífugas de Mesa" =>{}
      },
      "Destiladores" =>{},
      "Dispensadores" =>{},
      "Estufas" =>{
        "Secado" =>{},
        "Cultivo" =>{},
        "Esterilización " =>{},
        "Aire Forzado" =>{}
      },
      "Lavadoras Ultrasónicas" =>{
        "De Mesa" =>{}
      },
      "Lavadores" =>{
        "Para Microplacas" =>{},
        "Para Pipetas/Buretas" =>{}
      },
      "Lectores" =>{
        "Para Microplacas" =>{}
      },
      "Micropipetas" =>{
        "Volumen Variable" =>{},
        "Volumen Fijo" =>{},
        "Multicanales" =>{},
        "Electrónicas" =>{},
        "Accesorios" =>{}
      },
      "Microscopios" =>{
        "Biológicos" =>{},
        "Metalográficos" =>{},
        "Estéreos" =>{},
        "Para Fluorescencia" =>{},
        "Video Microscopio" =>{},
        "Refractómetros" =>{}
      },
      "Otros" =>{},
      "Biología Molecular" =>{},
      "Cardiología" =>{},
      "Coagulación" =>{},
      "Contadores Hematológicos" =>{},
      "Hormonas/Endocrinología " =>{},
      "Medio Interno" =>{},
      "Orina" =>{},
      "Química Clínica" =>{},
      "Software" =>{}
    },
    "Insumos" =>{
      "Bacteriología" =>{},
      "Biología Molecular" =>{},
      "Cardiología" =>{},
      "Coagulación" =>{},
      "Drogas y Reactivos" =>{},
      "Hematología" =>{},
      "Hormonas/Endocrinología" =>{},
      "Inmunología" =>{},
      "Marcadores Tumorales" =>{},
      "Medio Interno" =>{},
      "Orina" =>{},
      "Química Clínica" =>{},
      "Sistema Vacutainer" =>{},
      "Screening" =>{},
      "Serología" =>{},
      "Test Rápidos" =>{},
      "Otros" =>{}
    },
    "Descartables" =>{
      "Matetial de Plástico" =>{
        "Agujas" =>{},
        "Bolsas" =>{},
        "Cassettes" =>{},
        "Crioviales" =>{},
        "Eppendorf" =>{},
        "Gradillas" =>{},
        "Hisopos" =>{},
        "Jeringas" =>{},
        "Pipetas" =>{},
        "Placas de Petri" =>{},
        "Recolectores para Heces" =>{},
        "Recolectores para Orina" =>{},
        "Tips" =>{},
        "Tubos Preparados" =>{},
        "Tubos Secos" =>{},
        "Otros" =>{}
      },
      "Material de Vidrio" =>{
        "Botellas" =>{},
        "Buretas" =>{},
        "Camara de Neubauer" =>{},
        "Capilares" =>{},
        "Cubrecamaras" =>{},
        "Cubreobjetos" =>{},
        "Embudos" =>{},
        "Erlenmeyer" =>{},
        "Frascos" =>{},
        "Jeringas" =>{},
        "Kitasatos" =>{},
        "Matraces" =>{},
        "Pipetas" =>{},
        "Placas de Petri" =>{},
        "Portaobjetos" =>{},
        "ProbetasTubos" =>{},
        "Vasos de Precipitados" =>{},
        "Otros" =>{}
      },
      "Material en General" =>{
        "Alcohol" =>{},
        "Algodón" =>{},
        "Ansas" =>{},
        "Apósitos" =>{},
        "Cepillos" =>{},
        "Cestos" =>{},
        "Cintas" =>{},
        "Etiquetas" =>{},
        "Gradillas" =>{},
        "Guantes" =>{},
        "Precintos" =>{},
        "Tapones" =>{},
        "Termómetros" =>{},
        "Timer" =>{},
        "Otros" =>{}
      }
    }
  }
end

