from django.contrib import admin

from .models import Continente, Pais, ApelidoDePais, GrupoGeopolitico, \
    PaisesParaGruposGeopoliticos, Universidade, ApelidoDeUniversidade, GrupoDeUniversidades, UniversidadesParaGrupos, \
    Ranking, Pilar, GrupoDePilares, PilaresParaGrupos, PilarValor


# ------------------ #
# ----- Países ----- #
# ------------------ #

class PaisInline(admin.TabularInline):
    model = Pais
    extra = 0
    verbose_name = 'País'
    verbose_name_plural = 'Países'
    readonly_fields = ['nome_portugues', 'nome_ingles']


class ContinenteAdmin(admin.ModelAdmin):
    model = Continente

    ordering = ['nome_portugues', 'nome_ingles']
    fieldsets = [
        (None, {'fields': ['nome_portugues', 'nome_ingles']})
    ]
    list_display = ('nome_portugues', 'nome_ingles')
    search_fields = ['nome_portugues', 'nome_ingles']
    inlines = [PaisInline]


class ApelidoDePaisInline(admin.TabularInline):
    model = ApelidoDePais
    extra = 0


class GruposGeopoliticosInline(admin.TabularInline):
    model = PaisesParaGruposGeopoliticos
    fk_name = 'pais'
    verbose_name = 'Grupo Geopolítico'
    verbose_name_plural = 'Grupos Geopolíticos'
    extra = 0


class PaisesDeGrupoGeopoliticoInline(admin.TabularInline):
    model = PaisesParaGruposGeopoliticos
    fk_name = 'grupo_geopolitico'
    verbose_name = 'Países no Grupo Geopolitico'


class GrupoGeopoliticoAdmin(admin.ModelAdmin):
    model = GrupoGeopolitico
    inlines = [PaisesDeGrupoGeopoliticoInline]

    ordering = ['nome_portugues', 'nome_ingles']
    fieldsets = [
        (None, {'fields': ['nome_portugues', 'nome_ingles']})
    ]

    list_display = ('nome_portugues', 'nome_ingles')
    search_fields = ['nome_portugues', 'nome_ingles']


class PaisAdmin(admin.ModelAdmin):
    ordering = ['nome_portugues']
    fieldsets = [
        (None, {'fields': ['nome_portugues', 'nome_ingles', 'continente']})
    ]
    inlines = [ApelidoDePaisInline, GruposGeopoliticosInline]
    list_display = ('nome_portugues', 'nome_ingles', 'continente')
    search_fields = ['nome_portugues', 'nome_ingles', 'continente__nome_portugues']
    exclude = ['paises']


admin.site.register(Continente, ContinenteAdmin)
admin.site.register(Pais, PaisAdmin)
admin.site.register(GrupoGeopolitico, GrupoGeopoliticoAdmin)

# ------------------------- #
# ----- Universidades ----- #
# ------------------------- #


# class MetricaValorDeUniversidadeInline(admin.TabularInline):
#     model = MetricaValor
#     extra = 0
#     verbose_name = 'Métrica'
#     verbose_name_plural = 'Métricas'
#
#     ordering = ['-ano', 'metrica']
#
#     readonly_fields = ['ano']
#     fieldsets = [
#         (None, {'fields': ['ano', 'metrica', 'valor_inicial', 'valor_final']})
#     ]


# class PilarValorDeUniversidadeInline(admin.TabularInline):
#     model = PilarValor
#     extra = 0
#     verbose_name = 'Pilar'
#     verbose_name_plural = 'Pilares'
#
#     ordering = ['-ano', 'universidade', 'pilar']
#
#     readonly_fields = ['ano', 'universidade', 'ranking', 'pilar']
#     fieldsets = [
#         (None, {'fields': ['ano', 'universidade', 'ranking', 'pilar', 'valor_inicial', 'valor_final']})
#     ]


class ApelidoDeUniversidadeInline(admin.TabularInline):
    model = ApelidoDeUniversidade
    extra = 0


class UniversidadesDeGruposDeUniversidadesInline(admin.TabularInline):
    model = UniversidadesParaGrupos
    fk_name = 'grupo_universidades'
    verbose_name = 'Universidades no Grupo'
    extra = 0


class GruposDeUniversidadesDeUniversidadeInline(admin.TabularInline):
    model = UniversidadesParaGrupos
    fk_name = 'universidade'
    verbose_name = 'Grupos aos quais esta universidade pertence'
    extra = 0


class GrupoDeUniversidadesAdmin(admin.ModelAdmin):
    model = GrupoDeUniversidades
    fieldsets = [
        (None, {'fields': ['nome_portugues', 'nome_ingles']})
    ]
    inlines = [UniversidadesDeGruposDeUniversidadesInline]
    list_display = ('nome_portugues', 'nome_ingles')
    search_fields = ['nome_portugues', 'nome_ingles']


class UniversidadeAdmin(admin.ModelAdmin):
    ordering = ['nome_portugues']
    fieldsets = [
        (None, {'fields': ['nome_portugues', 'nome_ingles', 'sigla', 'pais_apelido']})
    ]
    inlines = [
        ApelidoDeUniversidadeInline, GruposDeUniversidadesDeUniversidadeInline,
        # PilarValorDeUniversidadeInline, MetricaValorDeUniversidadeInline
    ]
    list_display = ('nome_portugues', 'nome_ingles', 'sigla', 'pais')  # 'pais_apelido')
    search_fields = [
        'nome_portugues', 'nome_ingles',
        'sigla',
        'pais_apelido__pais__nome_portugues',
        'pais_apelido__pais__nome_ingles',
        'pais_apelido__apelido'
    ]
    exclude = ['universidades']


admin.site.register(Universidade, UniversidadeAdmin)
admin.site.register(GrupoDeUniversidades, GrupoDeUniversidadesAdmin)

# -------------------- #
# ----- Rankings ----- #
# -------------------- #


class PilarValorAdmin(admin.ModelAdmin):
    model = PilarValor
    ordering = ['-ano', 'id_universidade', 'id_pilar']
    fieldsets = [
        (None, {'fields': ['ano', 'id_universidade', 'ranking', 'id_pilar', 'valor_inicial', 'valor_final']})
    ]

    list_display = ('ano', 'ranking', 'id_universidade', 'id_pilar', 'valor_inicial', 'valor_final')
    search_fields = (
        'ano', 'id_universidade__nome_portugues', 'id_universidade__sigla',
        'id_pilar__nome_portugues'
    )


class PilarDeRankingInline(admin.TabularInline):
    model = Pilar
    extra = 0


class RankingAdmin(admin.ModelAdmin):
    model = Ranking
    inlines = [PilarDeRankingInline]

    search_fields = ['nome_ranking']


class PilaresDeGrupoDePilaresInline(admin.TabularInline):
    model = PilaresParaGrupos
    fk_name = 'grupo_pilares'
    verbose_name = 'Pilar no Grupo'
    verbose_name_plural = 'Pilares no Grupo'
    extra = 0

    ordering = ['pilar']

    readonly_fields = []
    fieldsets = [
        (None, {'fields': ['pilar']})
    ]


class GrupoDePilaresAdmin(admin.ModelAdmin):
    model = GrupoDePilares
    inlines = [PilaresDeGrupoDePilaresInline]

    ordering = ['nome_portugues']
    search_fields = ['id_grupo__nome_portugues']


admin.site.register(Ranking, RankingAdmin)
admin.site.register(GrupoDePilares, GrupoDePilaresAdmin)
