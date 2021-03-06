###############
# Commit Type #
###############

type Commit <: GitHubType
    sha::Nullable{GitHubString}
    message::Nullable{GitHubString}
    author::Nullable{Owner}
    committer::Nullable{Owner}
    commit::Nullable{Commit}
    url::Nullable{HttpCommon.URI}
    html_url::Nullable{HttpCommon.URI}
    comments_url::Nullable{HttpCommon.URI}
    parents::Nullable{Vector{Commit}}
    stats::Nullable{Dict}
    files::Nullable{Vector{Content}}
    comment_count::Nullable{Int}
end

Commit(data::Dict) = json2github(Commit, data)
Commit(sha::AbstractString) = Commit(Dict("sha" => sha))

namefield(commit::Commit) = commit.sha

###############
# API Methods #
###############

function commits(repo; options...)
    results, page_data = gh_get_paged_json("/repos/$(name(repo))/commits"; options...)
    return map(Commit, results), page_data
end

function commit(repo, sha; options...)
    result = gh_get_json("/repos/$(name(repo))/commits/$(name(sha))"; options...)
    return Commit(result)
end
