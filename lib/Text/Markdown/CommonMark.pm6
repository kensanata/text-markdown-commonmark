# Text::Markdown::CommonMark is a Markdown-to-HTML converter
# Copyright (C) 2018  Alex Schroeder <alex@gnu.org>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>.

=begin pod

=head1 Text::Markdown::CommonMark

    use Text::Markdown::CommonMark;
    my $md = parse-markdown($raw-md);
    say $md.to_html;

=end pod

class Text::Markdown::CommonMark {

    has Str $.html is rw;

    method to-html {
        return $.html;
    }

    method to_html(Nil --> Str) {
        return $.html;
    }
}

grammar Text::Markdown::CommonMark::Grammar {
    rule TOP {
        ^
        <block>*
        $
    }

    rule block {
        <paragraph> ( <blank-line>+ <paragraph> )*
    }

    rule paragraph {
        <line> ( <line-ending> <line> )*
    }

    rule line {
        <-[ \n \r ]>+
    }

    rule line-ending {
        ( \n | \r <!before \n> | \n \r )
    }

    rule blank-line {
        ^^
        [ \t]*
        $$
    }
}

class Text::Markdown::CommonMark::ToHtml {

    method paragraph($/) {
        # FIXME how to do this?
        $/.make('<p>' ~ $/ ~ '</p>');
    }

    method line-ending {
        $/.make("\n");
    }

    method blank-line {
        $/.make("\n");
    }
}

sub parse-markdown(Str $raw-md --> Text::Markdown::CommonMark) is export {
    return Text::Markdown::CommonMark.new(
        html => Text::Markdown::CommonMark::Grammar.parse(
            $raw-md, :actions(Text::Markdown::CommonMark::ToHtml.new)).Str);
}
