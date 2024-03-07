from django import template

register = template.Library()


@register.inclusion_tag('rankings/pillars/merger/input_group.html')
def generate_input_group(ranking, id_group):
    return {
        'ranking': ranking,
        'id_group': id_group
    }
