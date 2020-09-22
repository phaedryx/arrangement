practice -* client -* patient



create_test_objects practice: {}

practice = create_test_objects practice: {
  name: 'All Dogs Go to Heaven'
}

practice = create_test_objects practice: {
  clients: [
    { first_name: 'Bob' },
    { first_name: 'Steve' }
  ]
}

practice = create_test_objects practice: {
  client: {
    patients: [
      {
        name: 'Phydeaux',
        birth_date: Date.today
      },
      {
        name: 'Ralph',
        birth_date: Date.today,
        deceased_date: 3.days.ago
      }
    ]
  }
}

owner, pet = create_test_objects practice: {
  client: {
    RETURN: true,
    patient: {
      RETURN: true,
      name: 'Ralph',
      birth_date: Date.today,
      deceased_date: 3.days.ago
    }
  }
}

create_test_objects practice: {
  clients: [{}, {}, {}]
}

yaml files:

label:
  practice:
    name: Healthy Pets
    client:
      first_name: John
      last_name: Dough

label2:
  practice:
    name: Healthy Pets
    client:
      RETURN: true
      first_name: John
      last_name: Dough


practice = Mygem.get(:label)
client = Mygem.get(:label2)


client.yaml
id: <%= sequence_generator %>
first_name: Bob
last_name: Jones

practice.yaml
id: <%= sequence_generator %>
name: Practice Name


rails g model Practice