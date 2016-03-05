import ceylon.html {
    ...
}

Html createLoremIpsumHtml() {
    value html = Html {
        Body {
            H1 { "Quae hic rei publicae vulnera inponebat, eadem ille sanabat." },
            P { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tamen intellego quid velit. Heri, inquam, 
                 ludis commissis ex urbe profectus veni ad vesperum. Ergo, inquit, tibi Q. Est autem a te semper dictum 
                 nec gaudere quemquam nisi propter corpus nec dolere."
            },
            H4 { "Tum Piso: Quoniam igitur aliquid omnes, quid Lucius noster?" },
            P { Span { "Hic ambiguo ludimur." }, B { "Stoici scilicet." },
                "Ergo ita: non posse honeste vivi, nisi honeste vivatur? ",
                I { "At enim sequor utilitatem" },
                A { href = "http://loripsum.net/"; target = "_blank"; "Quid Zeno?" },
                "Itaque hic ipse iam pridem est reiectus; Quod autem satis est, eo quicquid accessit, nimium est; Ait enim 
                 se, si uratur, Quam hoc suave! dicturum."
            },
            Dl {
                Dt { Dfn { "ALIO MODO." } },
                Dd { "Quis istud possit, inquit, negare?" },
                Dt { Dfn { "Sullae consulatum?" } },
                Dd { "Quaeque de virtutibus dicta sunt, quem ad modum eae semper voluptatibus inhaererent, eadem de amicitia dicenda sunt." },
                Dt { Dfn { "Perge porro;" } },
                Dd { "Quae sequuntur igitur?" },
                Dt { Dfn { "An eiusdem modi?" } },
                Dd { "Graecum enim hunc versum nostis omnes-: Suavis laborum est praeteritorum memoria" },
                Dt { Dfn { "Deprehensus omnem poenam contemnet." } },
                Dd { "Ita fit cum gravior, tum etiam splendidior oratio." }
            },
            Ol {
                Li { "Sed in rebus apertissimis nimium longi sumus." },
                Li { "Atque haec contra Aristippum, qui eam voluptatem non modo summam, sed solam etiam ducit, quam omnes unam appellamus voluptatem." },
                Li { "Summae mihi videtur inscitiae." },
                Li { "Etenim semper illud extra est, quod arte comprehenditur." },
                Li { "Quae fere omnia appellantur uno ingenii nomine, easque virtutes qui habent, ingeniosi vocantur." },
                Li { "Si quicquam extra virtutem habeatur in bonis." },
                Li { "Haec bene dicuntur, nec ego repugno, sed inter sese ipsa pugnant." }
            },
            Ul {
                Li { "Sequitur disserendi ratio cognitioque naturae;" },
                Li { "Sed ad haec, nisi molestum est, habeo quae velim." }
            },
            P { "Qui ita affectus, beatum esse numquam probabis;",
                Code { "Haec quo modo conveniant, non sane intellego." },
                "Ex quo, id quod omnes expetunt, beate vivendi ratio inveniri et comparari potest. Qui ita affectus, 
                 beatum esse numquam probabis; Tecum optime, deinde etiam cum mediocri amico. "
            },
            H3 { "Nihil acciderat ei, quod nollet, nisi quod anulum, quo delectabatur, in mari abiecerat." },
            P { "Fortitudinis quaedam praecepta sunt ac paene leges, quae effeminari virum vetant in dolore. Quo 
                 plebiscito decreta a senatu est consuli quaestio Cn.",
                A { href = "http://loripsum.net/"; target = "_blank"; "Sed ad bona praeterita redeamus." },
                I { "Et nemo nimium beatus est;" },
                "Et quod est munus, quod opus sapientiae?"
            },
            Pre {
                "Si una virtus, unum istud, quod honestum appellas, rectum,
                 laudabile, decorumerit enim notius quale sit pluribus
                 notatum vocabulis idem declarantibus-, id ergo, inquam, si
                 solum est bonum, quid habebis praeterea, quod sequare?
                 
                 Illi enim inter se dissentiunt."
            },
            P { "Potius ergo illa dicantur: turpe esse, viri non esse debilitari dolore, frangi, succumbere.",
                B { "Immo videri fortasse." }, "Hoc est non dividere, sed frangere. ",
                A { href = "http://loripsum.net/"; target = "_blank"; "Si longus, levis;" },
                "Nec vero alia sunt quaerenda contra Carneadeam illam sententiam.", I { "Sed haec omittamus;" },
                "Theophrastus mediocriterne delectat, cum tractat locos ab Aristotele ante tractatos?",
                B { "Graccho, eius fere, aequalí?" },
                "Ergo in utroque exercebantur, eaque disciplina effecit tantam illorum utroque in genere dicendi 
                 copiam. Huius, Lyco, oratione locuples, rebus ipsis ielunior.",
                B { "Utilitatis causa amicitia est quaesita." },
                "Profectus in exilium Tubulus statim nec respondere ausus; " },
            P { "Quid censes in Latino fore? Illa argumenta propria videamus, cur omnia sint paria peccata. 
                 Quae cum magnifice primo dici viderentur, considerata minus probabantur. "
            },
            Blockquote { cite = "http://loripsum.net";
                "Quam similitudinem videmus in bestiis, quae primo, in quo loco natae sunt, ex eo se non commoventi deinde suo quaeque appetitu movetur."
            },
            Pre {
                "Quam si explicavisset, non tam haesitaret.
                 
                 Hoc tu nunc in illo probas."
            },
            Ol {
                Li { "Potius ergo illa dicantur: turpe esse, viri non esse debilitari dolore, frangi, succumbere." },
                Li { "Quae quidem vel cum periculo est quaerenda vobis;" },
                Li { "Illa argumenta propria videamus, cur omnia sint paria peccata." },
                Li { "In qua quid est boni praeter summam voluptatem, et eam sempiternam?" },
                Li { "Nihilne te delectat umquam -video, quicum loquar-, te igitur, Torquate, ipsum per se nihil delectat?" },
                Li { "Quam ob rem tandem, inquit, non satisfacit?" }
            },
            Blockquote { cite = "http://loripsum.net";
                "Praeclare Laelius, et recte sofñw, illudque vere: O Publi, o gurges, Galloni! es homo miser, inquit."
            },
            P { 
                B { "Duarum enim vitarum nobis erunt instituta capienda." }, 
                "Quasi ego id curem, quid ille aiat aut neget.", 
                Span { "Sed nimis multa." }, 
                "Sed tamen omne, quod de re bona dilucide dicitur, mihi praeclare dici videtur. Ita graviter et severe voluptatem 
                 secrevit a bono. Quid ergo attinet gloriose loqui, nisi constanter loquare? Beatus autem esse in maximarum rerum 
                 timore nemo potest. Itaque ab his ordiamur. Videamus animi partes, quarum est conspectus illustrior; " 
            },
            P { 
                "Ab his oratores, ab his imperatores ac rerum publicarum principes extiterunt.", 
                B { "Minime vero istorum quidem, inquit." }, 
                "Dic in quovis conventu te omnia facere, ne doleas. Respondent extrema primis, media utrisque, omnia omnibus. 
                 Hic nihil fuit, quod quaereremus. Eam tum adesse, cum dolor omnis absit; Zenonis est, inquam, hoc Stoici. Stuprata 
                 per vim Lucretia a regis filio testata civis se ipsa interemit.", 
                A { href = "http://loripsum.net/"; target = "_blank"; "Sed ad illum redeo." } 
            },
            H2 { "Duo Reges: constructio interrete." },
            P { 
                "Atqui reperies, inquit, in hoc quidem pertinacem; Quod si ita sit, cur opera philosophiae sit danda nescio. 
                 Miserum hominem! Si dolor summum malum est, dici aliter non potest. Qui non moveatur et offensione turpitudinis 
                 et comprobatione honestatis? Diodorus, eius auditor, adiungit ad honestatem vacuitatem doloris. Nondum autem 
                 explanatum satis, erat, quid maxime natura vellet. " 
            },
            Dl {
                Dt{Dfn{"Quonam modo?"}},
                Dd{"Quid ei reliquisti, nisi te, quoquo modo loqueretur, intellegere, quid diceret?"},
                Dt{Dfn{"Sullae consulatum?"}},
                Dd{"Omnes enim iucundum motum, quo sensus hilaretur."},
                Dt{Dfn{"Tubulo putas dicere?"}},
                Dd{"Ille vero, si insipiens-quo certe, quoniam tyrannus -, numquam beatus;"}
            },
            Ul {
                Li { "Nam illud vehementer repugnat, eundem beatum esse et multis malis oppressum."},
                Li { "Verum hoc loco sumo verbis his eandem certe vim voluptatis Epicurum nosse quam ceteros."},
                Li { "Minime id quidem, inquam, alienum, multumque ad ea, quae quaerimus, explicatio tua ista profecerit."}
            },
            P{
                Span{"Quid de Platone aut de Democrito loquar?"}, 
                I{"Optime, inquam."}, "Certe non potest.", B{"Proclivi currit oratio."}, 
                "Quamquam haec quidem praeposita recte et reiecta dicere licebit. Quod si ita se habeat, non possit beatam praestare vitam sapientia."
            }
        }
    };
    return html;
}