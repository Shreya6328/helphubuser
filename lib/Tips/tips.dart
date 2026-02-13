import 'package:flutter/material.dart';

void main() {
  runApp(const Tips());
}

class Tips extends StatelessWidget {
  const Tips({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmergencyListPage(),
    );
  }
}

// ================= MAIN LIST PAGE =================

class EmergencyListPage extends StatelessWidget {
  const EmergencyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _header(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              children: emergencies.map((e) {
                return _card(context, e);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Center(
            child: Text("Emergency Do's & Don'ts",
                style: TextStyle(
                    color: const Color.fromARGB(218, 2, 2, 2), fontSize: 22)),
          ),
        ),
        const Positioned(
          bottom: -35,
          left: 0,
          right: 0,
          child: Column(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Icon(Icons.rule, size: 30),
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(BuildContext context, Emergency e) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmergencyDetailPage(emergency: e),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 142, 213, 246),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  // Text(e.description,
                  //     style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

// ================= DETAILS PAGE =================

class EmergencyDetailPage extends StatelessWidget {
  final Emergency emergency;

  const EmergencyDetailPage({super.key, required this.emergency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A73FF),
        title: Text(emergency.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section("Before", emergency.beforeDo, emergency.beforeDont),
            _section("During", emergency.duringDo, emergency.duringDont),
            _section("After", emergency.afterDo, emergency.afterDont),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<String> dos, List<String> donts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
        ),
        ...dos.map((d) => _row(Icons.check_circle, Colors.green, d)),
        ...donts.map((d) => _row(Icons.cancel, Colors.red, d)),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _row(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// ================= DATA MODEL =================

class Emergency {
  final String title;
  // final String description;
  final List<String> beforeDo, beforeDont;
  final List<String> duringDo, duringDont;
  final List<String> afterDo, afterDont;

  Emergency({
    required this.title,
    // required this.description,
    required this.beforeDo,
    required this.beforeDont,
    required this.duringDo,
    required this.duringDont,
    required this.afterDo,
    required this.afterDont,
  });
}

// ================= ALL EMERGENCY DATA =================

final List<Emergency> emergencies = [
  // FLOOD
  Emergency(
    title: "Flood",
    // description: "Overflow of water submerging land.",
    beforeDo: [
      "1) 😌 Stay calm and trust official information.\n --> Ignore rumours and do not panic.\n",
      "2) 📱🔋 Keep your mobile phone charged. \n --> Use SMS/text messages for emergency communication\n",
      "3) 📻📺📰 Stay informed. \n --> Listen to radio, watch TV, and read newspapers for weather updates.\n",
      "4) 🐄🐕 Keep animals untied. \n --> This helps cattle and pets escape safely during floods.\n",
      "5) 🎒 Prepare an emergency kit. \n --> Include food, water, medicines, torch, batteries, and first aid items.\n",
      "6) 📄💼 Protect important documents. \n --> Keep documents and valuables in waterproof bags.\n",
      "7) 🛣️🏠 Know safe routes and shelters. \n --> Learn the way to the nearest shelter or raised pucca house.\n",
      "8) 🚨➡️ Evacuate when told. \n --> Move immediately to safe places when government officials give instructions.\n",
      "9) 🥫💧 Store enough food and water. \n --> Keep ready-to-eat food and drinking water for at least one week.\n",
      "10) ⚠️🌊 Be aware of flood-prone areas. \n --> Stay alert near canals, streams, drains, and low-lying areas.\n",
    ],
    beforeDont: [
      "1) 🗣️❌ Don’t believe or spread rumours. \n --> False information can cause fear and danger.\n",
      "2) ⚡🌊 Don’t go near floodwater. \n --> Avoid canals, drainage channels, and fast-moving water.\n",
      "3) ⏳🚫 Don’t delay evacuation. \n -->Leaving late can put your life at risk.\n",
      "4) 📄💦 Don’t leave documents unprotected. \n --> Water can destroy important papers.\n",
      "5) 😨🚫 Don’t panic. \n -->Fear can lead to wrong decisions.\n",
    ],
    duringDo: [
      "1) 👟 Wear proper footwear if you must enter water. \n --> Only enter floodwater if absolutely necessary, and wear strong shoes.\n",
      "2) 🚧🚩 Mark open drains and manholes. \n --> Use red flags, boards, or barricades to warn others.\n",
      "3) 🍲 Eat safe food. \n --> Eat freshly cooked or dry food and keep food covered.\n",
      "4) 💧🔥 Drink safe water. \n --> Drink boiled or chlorinated water only.\n",
      "5) 🧼🦠 Keep surroundings clean. \n --> Use disinfectants to prevent infections and diseases.\n",
    ],
    duringDont: [
      "1) 🌊🚫 Don’t enter floodwaters. \n --> Floodwater may be deep, fast, and dangerous.\n",
      "2) 🚽🚫 Don’t go near drains or sewer lines. \n --> Avoid gutters, drains, culverts, and sewage lines.\n",
      "3) ⚡🚫 Don’t go near electric poles or wires. \n --> Stay away from fallen power lines to avoid electrocution.\n",
      "4) 🚶‍♂️🚗🚫 Don’t walk or drive through floodwater. \n --> Just 2 feet of moving water can wash away vehicles, even big cars.\n",
      "5) 🥗💦 Don’t eat uncovered or contaminated food . \n --> Floodwater can spoil food and cause illness.\n",
    ],
    afterDo: [
      "1) ⚡🔌 Switch off electricity if instructed. \n --> Turn off power at the main switch and unplug appliances. \n\n 👉 Do this only if your hands and the area are dry.\n",
      "2)🔎⚠️ Stay alert to dangers. \n --> Watch out for broken electric poles, loose wires, sharp objects, and debris.\n",
      "3) 🦟🛏️ Use mosquito nets. \n --> Protect yourself from malaria and other mosquito-borne diseases.\n",
      "4) 🐍⚠️ Be careful of snakes. \n --> Snakes often move to dry places during floods.\n",
      "5) 🚰❌➡️💧✔️ Use safe water only. \n -->Drink water only after authorities say it is safe.\n",
    ],
    afterDont: [
      "1) 👶🌊🚫 Don’t allow children near floodwater. \n --> Floodwater is dangerous and can cause injury or disease.\n",
      "2) 🔌🚫 Don’t use damaged electrical items. \n --> Get them checked by an electrician before use.\n",
      "3) ⚡💦🚫 Don’t touch electrical equipment if wet. \n --> Water and electricity can cause serious shock.\n",
      "4) 🍽️🌊🚫 Don’t eat food touched by floodwater. \n --> It may be contaminated and unsafe.\n",
      "5) 🚽🚰🚫 Don’t use toilets or tap water if pipes are damaged. \n --> Broken sewage or water lines can spread disease.\n",
      "6) 💧🚫 Don’t drink tap water until declared safe. \n --> Wait for instructions from the Health Department.\n",
    ],
  ),

  // EARTHQUAKE
  Emergency(
    title: "Earthquake",
    // description: "Sudden shaking of the earth.",
    beforeDo: [
      "1) 🧯 Keep emergency supplies at home. \n  --> Have a fire extinguisher, first aid kit, battery radio, torch, and extra batteries ready. \n ",
      "2) 🚑 Learn first aid. \n  --> Basic first aid knowledge can help save lives during emergencies. \n ",
      "3) 🔌🚰🔥 Know how to turn off gas, water & electricity. \n  --> This helps prevent fire, flooding, and electric shocks. \n ",
      "4) 👨‍👩‍👧‍👦 Make a family meeting plan. \n  --> Decide a safe place to meet your family after an earthquake. \n ",
      "5) 🪑🔩 Secure heavy furniture and appliances. \n  --> Fix cupboards, shelves, TVs, and fridges to walls or floors. \n ",
      "6) 🏫🏢 Know your school/workplace earthquake plan. \n  --> Learn evacuation routes and safety instructions. \n ",
    ],
    beforeDont: [
      "1) 📦⬆️ Don’t keep heavy objects on shelves \n --> They can fall during shaking and cause injuries. \n ",
      "2) 🚪❓ Don’t ignore safety plans \n --> Not knowing what to do can cause panic and confusion. \n ",
      "3) ⚠️ Don’t keep emergency items scattered \n --> Keep them in one place so they are easy to find. \n ",
      "4) 🧱 Don’t leave furniture unsecured \n --> Loose furniture can fall and hurt people during an earthquake. \n ",
    ],
    duringDo: [
      "1) 😌 Stay calm. \n  --> Remain calm and protect yourself. \n ",
      "2)🏠 Stay where you are. \n  --> (1) If you are indoors, stay inside.\n  -->(2) If you are outdoors, stay outside in an open area. \n ",
      "3) 🪑🧱🚪 Take safe shelter indoors .\n  --> (1) Stay near an inside wall.\n  -->(2) Stand in a doorway, or\n  --> (3) Get under a strong table or desk. \n ",
      "4) 🌳 Move to open space outdoors. \n  --> Stay away from buildings, trees, power lines, and poles. \n ",
      "5) 🚗 If in a vehicle, stop safely. \n  --> Pull over and stay inside the car until the shaking stops. \n ",
    ],
    duringDont: [
      "1) 🪟🚪 Don’t go near windows or outside doors. \n -->  Glass can break and cause injuries. \n ",
      "2) 🔥🚫 Don’t use matches, candles, or flames. \n -->  Gas leaks can cause fire or explosions. \n ",
      "3) 🏃‍♂️🚫 Don’t run during shaking. \n -->  Running can cause falls and injuries. \n ",
      "4) 🛗🚫 Don’t use elevators. \n -->  They may stop working during an earthquake. \n ",
      "5) 🏢⬇️ Don’t stand close to buildings when outside. \n -->  Objects may fall from buildings. \n ",
    ],
    afterDo: [
      "1) 🩹 Check for injuries. \n --> Look after yourself and others. Give first aid if needed.  \n",
      "2) 🔌🚰🔥 Check utilities.\n -->  Inspect gas, water, and electricity lines. Turn off any damaged valves. \n",
      "3) 👃🔥🚪 If you smell gas.\n --> Open windows and doors. \n --> (2)Leave the building immediately. \n --> (3)Report to authorities using someone else’s phone \n",
      "4) 📻 Listen to updates.\n -->  Use a battery-powered radio for news and instructions. \n",
      "5) 🧱🪟 Be careful of debris.\n --> Wear boots or sturdy shoes to protect your feet from broken glass or rubble. \n",
      "6) 🏫🏢 Follow safety plans.\n --> At school or work, listen to the person in charge and follow emergency procedures. \n",
      "7) 🔁 Expect aftershocks.\n --> Be ready for more shaking after the main quake. \n",
    ],
    afterDont: [
      "1) 🏚️🚫 Don’t enter damaged buildings.\n  -->  They can collapse or be unsafe.\n",
      "2)🏗️⚠️ Don’t go near chimneys.\n  -->  Damaged chimneys may fall without warning. \n",
      "3)🌊🚫 Don’t go to beaches.\n  -->  Tsunamis or strong waves may occur after earthquakes.\n ",
      "4) 🚧🚫 Don’t go to dangerous or damaged areas.\n  -->  Avoid collapsed buildings, landslides, or unstable roads.\n",
      "5)📵 Don’t use phones unnecessarily.\n  -->  Keep phone lines free for emergencies only.\n ",
    ],
  ),

  // Fire
  Emergency(
    title: "Fire",
    // description: "Strong winds and heavy rain.",
    beforeDo: [
      "1) 🚨 Install smoke alarms. \n  --> Put smoke alarms on every floor and near bedrooms. Test them every month. \n",
      "2) 🚪 Make an escape plan. \n  --> Plan two exits from each room and choose a safe meeting place outside. \n",
      "3) 🏃‍♂️ Practice fire drills. \n  --> Practice fire escape drills with your family regularly. \n",
      "4) ⚡ Use electricity safely. \n  --> Do not overload plugs. Check wires and unplug unused appliances. \n",
      "5) 🍳 Stay safe in the kitchen. \n  --> Keep cooking areas clean. Tie long hair. Never leave cooking unattended. \n",
      "6) 🎒 Prepare an emergency kit. \n  --> Keep food, water, first aid, and copies of important documents ready. \n",
    ],
    beforeDont: [
      "1) 🔌🚫 Don’t overload power sockets. \n --> Too many plugs can cause fire. \n",
      "2) 🍳🚫 Don’t leave cooking unattended. \n --> Unattended cooking can start a fire. \n",
      "3) 🧯🚫 Don’t ignore fire safety drills. \n --> Practice helps save lives. \n",
      "4) ⚡🚫 Don’t use damaged wires or appliances .\n --> They can cause electric fires. \n",
      "5) 🗂️🚫 Don’t keep documents unsecured. \n --> Always keep copies safe and ready. \n",
    ],
    duringDo: [
      "1)😌🚨 Stay calm and alert others. \n  -->  Pull the fire alarm and shout “Fire!” to warn everyone. \n",
      "2)🏃‍♂️➡️ Evacuate immediately. \n  -->  Leave the building as fast as possible. \n",
      "3)✋🚪 Check doors before opening. \n  -->  Touch the door with the back of your hand. \n",
      "4)⬇️😷 Stay low under smoke. \n  -->  Crawl close to the floor to avoid breathing toxic smoke. \n",
      "5)🏠➡️📍 Go to your meeting place. \n  -->  Once outside, go to the decided safe meeting spot. \n",
      "6)📞🚒 Call the fire department. \n  --> From a safe place, use a mobile or neighbor’s phone. \n",
    ],
    duringDont: [
      "1)🎒🚫 Don’t go back for belongings. \n  --> Your life is more important than things.  \n",
      "2)🏠🚫 Don’t re-enter the building. \n  --> Once out, stay out.  \n",
      "3)😱🚫 Don’t panic or hide. \n  --> Panic can slow you down and cause danger.  \n",
      "4)🛗🚫 Don’t use elevators. \n  --> Always use stairs during a fire.  \n",
    ],
    afterDo: [
      "1) ⏳🚒 Wait for official clearance. \n -->  Enter the building only when firefighters say it is safe. \n",
      "2) 🩹🔥 Check for injuries. \n -->  Cool burns with clean, cool water and get medical help if needed. \n",
      "3) 📸🏚️ Check and record damage. \n --> Take photos and note damage for insurance. Be careful while cleaning. \n",
      "4) 📞🏢 Contact important services. \n -->  Inform insurance companies, utility services, and local authorities. \n",
      "5) 🧠💬 Get emotional support. \n --> Seek help for stress or trauma after the fire. \n",
    ],
    afterDont: [
      "1)🏠🚫 Don’t enter damaged buildings early. \n  -->  Hidden dangers may still exist. \n",
      "2) 🔥🚫 Don’t ignore injuries. \n  -->  Even small burns need attention. \n",
      "3) 🧹🚫 Don’t clean without caution. \n  -->  Sharp objects and weak structures can hurt you. \n",
      "4) 📑🚫 Don’t delay reporting damage. \n  -->  Late reporting can cause problems with insurance. \n",
      "5) 😔🚫 Don’t handle stress alone. \n  -->  Talk to family, friends, or professionals. \n",
    ],
  ),

  // Medical
  Emergency(
    title: "Medical",
    // description: "Extreme temperature rise.",
    beforeDo: [
      "1) 😴 Sleep well before the checkup. \n  -->  Good sleep helps keep blood pressure and test results normal. \n",
      "2) ⏳🥤 Follow fasting instructions. \n  -->  If told to fast, don’t eat or drink anything except water for 8–12 hours. \n",
      "3) 💧 Stay hydrated if advised. \n  -->  Drink enough water, especially before tests like ultrasound. \n",
      "4) 🩺💬 Talk to your doctor. \n  -->  Share your medical history, medicines, and symptoms. \n",
    ],
    beforeDont: [
      "1) 🏋️‍♀️ Avoid heavy exercise. \n  -->  Strenuous activity can raise heart rate and blood pressure. \n",
      "2) 💊 Don’t change medicines on your own. \n  -->  Ask your doctor before stopping or skipping any medicine. \n",
      "3) 🍔🍟 Avoid junk and heavy food. \n  -->  Salty, sugary, or oily food can affect test results. \n",
    ],
    duringDo: [
      "1) 🗣️ Be honest with your doctor. \n  -->  Share correct details about your health and lifestyle. \n",
      "2) ❓ Ask questions. \n  -->  If you are confused or worried, ask the doctor or nurse. \n",
      "3) 📋 Mention current medicines. \n  -->  Tell the doctor about all medicines or supplements you take. \n",
      "4) 📝 Listen and take notes. \n  -->  Remember or write down important instructions. \n",
    ],
    duringDont: [
      "1) ⏱️ Don’t rush the appointment. \n --> Take time to understand everything properly. \n",
      "2) 📵 Avoid distractions. \n --> Don’t use your phone during the consultation. \n",
      "3) 🤐 Don’t hide symptoms. \n  --> Even small problems are important to mention. \n",
      "4) 🚫 Don’t interrupt. \n  --> Let the doctor finish explaining. \n",
    ],
    afterDo: [
      "1) ✅ Follow doctor’s instructions. \n  --> Follow advice about food, activity, and medicines after tests. \n",
      "2) 📅 Book follow-up visits. \n  --> Schedule any tests or appointments suggested by your doctor. \n",
      "3) 📝 Keep reports safe. \n  --> Save test results for future reference. \n",
      "4) 💊 Take medicines on time. \n  --> Follow the prescribed dose and timing. \n",
      "5) 📞 Clarify doubts later. \n  --> Call or visit your doctor if anything is unclear. \n",
    ],
    afterDont: [
      "1) 🚨 Don’t ignore symptoms. \n --> Contact your doctor if you feel unwell after the checkup. \n",
      "2) 🌐 Don’t self-diagnose online. \n --> Trust your doctor to explain test results properly. \n",
      "3) ❌ Don’t skip follow-ups. \n --> Missing appointments can delay treatment. \n",
      "4) ⚠️ Don’t change medicines yourself. \n --> Always consult your doctor before making changes. \n",
    ],
  ),

  //  Accident
  Emergency(
    title: "Accident",
    // description: "Extreme temperature rise.",
    beforeDo: [
      "1) 🧯 Keep emergency items ready. \n  --> Store first aid kit, torch, and emergency numbers. \n",
      "2) 👟 Wear proper footwear. \n  --> Use non-slip shoes to avoid falls. \n",
      "3) 🚧 Follow safety rules. \n  --> Obey traffic and workplace safety instructions. \n",
      "4) 🪖 Use safety gear. \n  --> Wear helmet, seatbelt, or protective equipment. \n",
      "5) 🔍 Check surroundings. \n  --> Stay alert in crowded or risky areas. \n",
    ],
    beforeDont: [
      "1) 📱 Don’t use phone while walking or driving. \n  --> Distractions can cause accidents. \n",
      "2) ⚠️ Don’t ignore safety signs. \n  --> Warning signs are there to protect you. \n",
      "3) 🚦 Don’t break traffic rules. \n  --> Overspeeding increases accident risk. \n",
    ],
    duringDo: [
      "1) 🆘 Stay calm. \n  --> Try not to panic and assess the situation. \n ",
      "2) 🚑 Call for help. \n  -->  Contact emergency services immediately. \n ",
      "3) 🩹 Give first aid if safe. \n  -->  Help the injured person without causing more harm. \n ",
      "4) 🚨 Secure the area. \n  -->  Warn others to prevent more accidents. \n ",
      "5) 🗣️ Follow instructions. \n  -->  Listen to emergency responders. \n ",
    ],
    duringDont: [
      "1) ❌ Don’t move the injured person. \n  -->  Unless there is danger like fire or traffic. \n ",
      "2) 🤕 Don’t apply pressure wrongly. \n  -->  Avoid touching serious wounds unnecessarily. \n ",
      "3) 📸 Don’t crowd or panic. \n  -->  Give space for rescue and help. \n ",
    ],
    afterDo: [
      "1) 🏥 Seek medical care. \n  -->  Get checked even if injuries seem minor. \n",
      "2) 📝 Report the accident. \n  -->  Inform authorities, workplace, or family. \n",
      "3) 🛌 Take proper rest. \n  -->  Allow the body time to heal. \n",
      "4) 📄 Keep records. \n  -->  Save medical reports and bills. \n",
      "5) 🧠 Learn from the incident. \n  -->  Take steps to avoid future accidents. \n",
    ],
    afterDont: [
      "1) 🚨 Don’t ignore pain or symptoms. \n --> Delayed treatment can be risky. \n",
      "2) 💊 Don’t self-medicate. \n --> Take medicines only prescribed by a doctor. \n",
      "3) 🕒 Don’t delay follow-up care. \n --> Attend all recommended checkups. \n",
    ],
  ),
  //  Violence
  Emergency(
    title: "Violence",
    // description: "Extreme temperature rise.",
    beforeDo: [
      "1) 👀 Stay aware of surroundings. \n  -->  Notice people, exits, and warning signs. \n",
      "2) 🤝 Avoid risky situations. \n  -->  Stay away from unsafe places or conflicts. \n",
      "3) 📞 Keep emergency contacts ready. \n  -->  Save police and trusted numbers on your phone. \n",
      "4) 🗺️ Plan safe routes. \n  -->  Choose well-lit and crowded paths when possible. \n",
      "5) 🧍‍♀️ Trust your instincts. \n  -->  Leave immediately if something feels unsafe. \n",
    ],
    beforeDont: [
      "1) 🍺 Don’t use alcohol or drugs. \n  -->  They reduce judgment and awareness. \n",
      "2) 😡 Don’t engage in arguments. \n  -->  Small fights can turn violent. \n",
      "3) 🌙 Don’t walk alone in unsafe areas. \n  -->  Especially late at night. \n",
    ],
    duringDo: [
      "1) 🧘 Stay calm and think clearly. \n  -->  Panic can make the situation worse. \n",
      "2) 🚪 Try to escape if safe. \n  -->  Move to a safe place quickly. \n",
      "3) 🗣️ Cooperate if needed. \n  -->  Your safety is more important than belongings. \n",
      "4) 📢 Get attention if safe. \n  -->  Shout or use alarms to attract help. \n",
      "5) 🛑 Follow clear instructions. \n  -->  Do what is asked if it keeps you safe. \n",
    ],
    duringDont: [
      "1) ❌ Don’t fight back unless unavoidable. \n  -->  It may increase danger. \n",
      "2) 📢 Don’t shout or provoke. \n  -->  Avoid actions that may anger the attacker. \n",
      "3) 🎥 Don’t try to record the incident. \n  -->  Focus on staying safe. \n",
    ],
    afterDo: [
      "1) 🚨 Contact police immediately. \n  -->  Report the incident as soon as possible. \n",
      "2) 🏥 Get medical help. \n  -->  Treat injuries even if they seem minor. \n",
      "3) 💬 Talk to someone you trust. \n  -->  Emotional support is important. \n",
      "4) 📝 Write down details. \n  -->  Note what happened while it’s fresh. \n",
      "5) 🧠 Seek counseling if needed. \n  -->  Mental health care helps recovery. \n",
    ],
    afterDont: [
      "1) 🤐 Don’t stay silent. \n  -->  Reporting helps prevent future violence. \n",
      "2) 🕒 Don’t delay help. \n  -->  Physical and mental care is important. \n",
      "3) 🚫 Don’t blame yourself. \n  -->  Violence is never your fault. \n",
    ],
  ),
];
