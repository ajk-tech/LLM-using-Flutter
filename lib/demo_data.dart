import 'package:flutter/material.dart';

enum AppLanguage { english, hindi }

enum SecurityTier {
  unclassified,
  confidential,
  secret;

  String label(AppLanguage language) {
    switch (this) {
      case SecurityTier.unclassified:
        return language == AppLanguage.hindi ? 'अवर्गीकृत' : 'UNCLASSIFIED';
      case SecurityTier.confidential:
        return language == AppLanguage.hindi ? 'गोपनीय' : 'CONFIDENTIAL';
      case SecurityTier.secret:
        return language == AppLanguage.hindi ? 'गुप्त' : 'SECRET';
    }
  }

  Color get color {
    switch (this) {
      case SecurityTier.unclassified:
        return const Color(0xFF0B7A43);
      case SecurityTier.confidential:
        return const Color(0xFFC56A00);
      case SecurityTier.secret:
        return const Color(0xFF8F1025);
    }
  }
}

class AppCopy {
  const AppCopy(this.language);

  final AppLanguage language;

  bool get hi => language == AppLanguage.hindi;

  String get appTitle => hi ? 'ऑन-प्रेम एआई चीफ-ऑफ-स्टाफ' : 'On-Prem AI Chief-of-Staff';
  String get office => hi ? 'माननीय केंद्रीय मंत्री का निजी कार्यालय' : 'Private Office of the Hon. Union Minister';
  String get search => hi ? 'आरएजी खोज' : 'RAG Search';
  String get coreModeSelection => hi ? 'कोर चयन' : 'Core selection';
  String get coreModeInstructions => hi ? 'सक्रिय कोर चुनें; यह खोज के फोकस और स्रोत व्यवहार को बदलता है।' : 'Select the active core; this switches the retrieval focus and source posture.';
  String get agentToolsTitle => hi ? 'एकीकृत एजेंट टूलसेट' : 'Integrated Agent Toolset';
  String get agentToolsSubtitle => hi ? 'एक एजेंट अब सभी संचार, व्हाट्सएप और कैलेंडर टास्क संभालता है।' : 'A single agent now handles all communication, WhatsApp, and calendar tasks.';
  String get communicationAgent => hi ? 'कम्युनिकेशन एजेंट' : 'Communication Agent';
  String get emailAgent => hi ? 'ईमेल' : 'Email';
  String get sendMail => hi ? 'मेल भेजें' : 'Send Mail';
  String get readMail => hi ? 'मेल पढ़ें' : 'Read Mail';
  String get summarizeMail => hi ? 'मेल को संक्षेप करें' : 'Summarize Mail';
  String get whatsAppAgent => hi ? 'व्हाट्सएप एजेंट' : 'WhatsApp Agent';
  String get sendWhatsApp => hi ? 'व्हाट्सएप भेजें' : 'Send WhatsApp';
  String get scheduleWhatsApp => hi ? 'व्हाट्सएप शेड्यूल करें' : 'Schedule WhatsApp';
  String get calendarAgent => hi ? 'कैलेंडर एजेंट' : 'Calendar Agent';
  String get createMeeting => hi ? 'मीटिंग बनाएँ' : 'Create Meeting';
  String get updateMeeting => hi ? 'मीटिंग अपडेट करें' : 'Update Meeting';
  String get cancelMeeting => hi ? 'मीटिंग रद्द करें' : 'Cancel Meeting';
  String get drafting => hi ? 'ड्राफ्टिंग स्टूडियो' : 'Drafting Studio';
  String get calendar => hi ? 'कार्य-सूची' : 'Calendar';
  String get approvals => hi ? 'अनुमोदन केंद्र' : 'Approval Center';
  String get languageLabel => hi ? 'हिन्दी' : 'English';
  String get maskSensitive => hi ? 'संवेदनशील विवरण मास्क करें' : 'Mask Sensitive Details';
  String get publicCore => hi ? 'PUBLIC Core' : 'PUBLIC Core';
  String get privateCore => hi ? 'PRIVATE Core' : 'PRIVATE Core';
  String get askPlaceholder => hi ? 'सुरक्षित खोज प्रश्न लिखें...' : 'Enter a secure search query...';
  String get send => hi ? 'भेजें' : 'Send';
  String get citations => hi ? 'स्रोत उद्धरण' : 'Source Citations';
  String get metadata => hi ? 'मेटाडाटा' : 'Metadata';
  String get queue => hi ? 'क्यू स्थिति: 3/12... क्रमिक प्रोसेसिंग' : 'Queue Position: 3/12... processing sequentially';
  String get load => hi ? 'Server Concurrency Load' : 'Server Concurrency Load';
  String get template => hi ? 'टेम्पलेट' : 'Template';
  String get sourcesUsed => hi ? 'प्रयुक्त स्रोत अंश' : 'Source Chunks Used';
  String get approve => hi ? 'Approve & Egress to Outbound Broker' : 'Approve & Egress to Outbound Broker';
  String get processing => hi ? 'आउटबाउंड ब्रोकर को भेजा जा रहा है...' : 'Egressing to outbound broker...';
  String get success => hi ? 'अनुमोदित: ड्राफ्ट आउटबाउंड ब्रोकर में जमा हुआ।' : 'Approved: draft placed in outbound broker.';
  String get outgoingQueue => hi ? 'आउटगोइंग ड्राफ्ट क्यू' : 'Outgoing Draft Queue';
  String get masked => hi ? '[प्रतिबंधित - मास्क]' : '[RESTRICTED - MASKED]';
  String get locationMasked => hi ? 'स्थान मास्क किया गया' : 'Location masked';
  String get confidence => hi ? 'विश्वास' : 'Confidence';
}

class SourceCitation {
  const SourceCitation({
    required this.title,
    required this.documentId,
    required this.repository,
    required this.owner,
    required this.updated,
  });

  final String title;
  final String documentId;
  final String repository;
  final String owner;
  final String updated;
}

class ChatReply {
  const ChatReply({
    required this.en,
    required this.hi,
    required this.citations,
  });

  final String en;
  final String hi;
  final List<SourceCitation> citations;

  String text(AppLanguage language) => language == AppLanguage.hindi ? hi : en;
}

class SourceChunk {
  const SourceChunk({
    required this.id,
    required this.title,
    required this.bodyEn,
    required this.bodyHi,
    required this.confidence,
  });

  final String id;
  final String title;
  final String bodyEn;
  final String bodyHi;
  final double confidence;

  String body(AppLanguage language) => language == AppLanguage.hindi ? bodyHi : bodyEn;
}

class CalendarEvent {
  const CalendarEvent({
    required this.time,
    required this.titleEn,
    required this.titleHi,
    required this.location,
    required this.sensitive,
    required this.tier,
  });

  final String time;
  final String titleEn;
  final String titleHi;
  final String location;
  final bool sensitive;
  final SecurityTier tier;

  String title(AppLanguage language) => language == AppLanguage.hindi ? titleHi : titleEn;
}

class ApprovalDraft {
  const ApprovalDraft({
    required this.id,
    required this.type,
    required this.subjectEn,
    required this.subjectHi,
    required this.previewEn,
    required this.previewHi,
    required this.recipient,
  });

  final String id;
  final String type;
  final String subjectEn;
  final String subjectHi;
  final String previewEn;
  final String previewHi;
  final String recipient;

  String subject(AppLanguage language) => language == AppLanguage.hindi ? subjectHi : subjectEn;
  String preview(AppLanguage language) => language == AppLanguage.hindi ? previewHi : previewEn;
}

const List<SourceCitation> coreCitations = <SourceCitation>[
  SourceCitation(
    title: 'Lok Sabha starred question index',
    documentId: 'PUB-LS-2026-QA-0142',
    repository: 'PUBLIC Core / Parliament',
    owner: 'Digital Cell',
    updated: '05 Jun 2026',
  ),
  SourceCitation(
    title: 'District implementation dashboard note',
    documentId: 'PRI-MIN-DASH-7781',
    repository: 'PRIVATE Core / Minister Office',
    owner: 'PS to Minister',
    updated: '04 Jun 2026',
  ),
];

const ChatReply publicReply = ChatReply(
  en: 'Public records indicate strong progress across citizen-service milestones, with three parliamentary references requiring careful attribution. Suggested briefing posture: highlight delivery metrics, cite the Lok Sabha answer index, and avoid operational claims beyond published figures.',
  hi: 'सार्वजनिक अभिलेख नागरिक-सेवा लक्ष्यों पर मजबूत प्रगति दिखाते हैं। तीन संसदीय संदर्भों में सावधानी से स्रोत देना चाहिए। सुझाव: वितरण आँकड़े प्रमुख रखें, लोक सभा उत्तर सूचकांक का उल्लेख करें, और प्रकाशित आँकड़ों से बाहर परिचालन दावा न करें।',
  citations: coreCitations,
);

const ChatReply privateReply = ChatReply(
  en: 'Private office notes add two sensitivities: a pending inter-ministerial concurrence and a field visit dependency. Recommended action: brief the Minister with the public line first, then add a restricted annex for decision points and owner accountability.',
  hi: 'निजी कार्यालय नोट दो संवेदनशील बिंदु जोड़ते हैं: लंबित अंतर-मंत्रालयी सहमति और क्षेत्रीय दौरे पर निर्भरता। अनुशंसा: मंत्री को पहले सार्वजनिक पंक्ति दें, फिर निर्णय बिंदुओं और जवाबदेही के लिए प्रतिबंधित परिशिष्ट जोड़ें।',
  citations: coreCitations,
);

const List<SourceChunk> sourceChunks = <SourceChunk>[
  SourceChunk(
    id: 'CH-PARL-12A',
    title: 'Parliament response baseline',
    bodyEn: 'Published scheme outcomes, verified beneficiary counts, and prior assurance language from parliamentary replies.',
    bodyHi: 'प्रकाशित योजना परिणाम, सत्यापित लाभार्थी संख्या, और पूर्व संसदीय उत्तरों की आश्वासन भाषा।',
    confidence: .94,
  ),
  SourceChunk(
    id: 'CH-MIN-44C',
    title: 'Minister office decision log',
    bodyEn: 'Internal note flags concurrence status, state coordination risk, and suggested speaking points.',
    bodyHi: 'आंतरिक नोट सहमति स्थिति, राज्य समन्वय जोखिम, और सुझाए गए बोलने बिंदु चिन्हित करता है।',
    confidence: .88,
  ),
  SourceChunk(
    id: 'CH-GIGW-03',
    title: 'GIGW accessibility checklist',
    bodyEn: 'Bilingual presentation, high contrast banners, keyboard-visible controls, and explicit document provenance.',
    bodyHi: 'द्विभाषी प्रस्तुति, उच्च-कॉन्ट्रास्ट बैनर, स्पष्ट नियंत्रण, और दस्तावेज़ स्रोत की पारदर्शिता।',
    confidence: .91,
  ),
];

const List<CalendarEvent> calendarEvents = <CalendarEvent>[
  CalendarEvent(
    time: '09:00',
    titleEn: 'Cabinet Meeting on Defense',
    titleHi: 'रक्षा विषयक कैबिनेट बैठक',
    location: 'South Block',
    sensitive: true,
    tier: SecurityTier.secret,
  ),
  CalendarEvent(
    time: '11:30',
    titleEn: 'Public grievance review',
    titleHi: 'जन शिकायत समीक्षा',
    location: 'Minister Office',
    sensitive: false,
    tier: SecurityTier.confidential,
  ),
  CalendarEvent(
    time: '14:00',
    titleEn: 'Industry delegation briefing',
    titleHi: 'उद्योग प्रतिनिधिमंडल ब्रीफिंग',
    location: 'Committee Room 3',
    sensitive: false,
    tier: SecurityTier.unclassified,
  ),
  CalendarEvent(
    time: '18:00',
    titleEn: 'Restricted coalition consultation',
    titleHi: 'प्रतिबंधित गठबंधन परामर्श',
    location: 'Residence Office',
    sensitive: true,
    tier: SecurityTier.secret,
  ),
];

const List<ApprovalDraft> approvalDrafts = <ApprovalDraft>[
  ApprovalDraft(
    id: 'OUT-EMAIL-209',
    type: 'Email',
    subjectEn: 'Response to CM Office on district rollout',
    subjectHi: 'जिला रोलआउट पर मुख्यमंत्री कार्यालय को उत्तर',
    previewEn: 'The Ministry acknowledges the state proposal and will convene a technical review within this fortnight.',
    previewHi: 'मंत्रालय राज्य प्रस्ताव स्वीकार करता है और इस पखवाड़े तकनीकी समीक्षा बुलाएगा।',
    recipient: 'State Coordination Desk',
  ),
  ApprovalDraft(
    id: 'OUT-BRIEF-541',
    type: 'Briefing Note',
    subjectEn: 'Morning brief: Parliament interventions',
    subjectHi: 'प्रातः ब्रीफ: संसद हस्तक्षेप',
    previewEn: 'Three interventions are ready for review, with public citations and a restricted risk annex.',
    previewHi: 'तीन हस्तक्षेप समीक्षा के लिए तैयार हैं, सार्वजनिक उद्धरण और प्रतिबंधित जोखिम परिशिष्ट सहित।',
    recipient: 'Private Secretary',
  ),
];
